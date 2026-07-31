import 'dart:async';
import 'dart:convert';

import 'package:fitness/config/api/ollama_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

class OllamaException implements Exception {
  const OllamaException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isRateLimited => statusCode == 429;

  /// Ollama Cloud returns 5xx sporadically for healthy requests, so those are
  /// worth retrying. A missing status means the request never completed.
  bool get isTransient =>
      statusCode == null || statusCode! >= 500 || statusCode == 408;

  /// The model exists but cannot serve this request (no image support, or the
  /// plan does not include it) - retrying will not help, another model might.
  bool get isModelUnavailable =>
      statusCode == 400 || statusCode == 403 || statusCode == 404;

  @override
  String toString() => 'OllamaException($statusCode): $message';
}

/// One assistant turn returned by a non-streamed request.
class OllamaChatResult {
  const OllamaChatResult({required this.content, required this.toolCalls});

  final String content;
  final List<Map<String, dynamic>> toolCalls;

  bool get hasToolCalls => toolCalls.isNotEmpty;
}

/// Talks to Ollama Cloud directly from the app - there is no gateway server.
@lazySingleton
class OllamaRemoteDatasource {
  OllamaRemoteDatasource() : _client = http.Client();

  @visibleForTesting
  OllamaRemoteDatasource.withClient(this._client);

  final http.Client _client;

  static const int _maxAttempts = 3;
  static const Duration _requestTimeout = Duration(seconds: 150);
  static const Duration _retryDelay = Duration(milliseconds: 700);

  /// Non-streamed turn, used when tool calls must arrive complete.
  Future<OllamaChatResult> chat({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
    String? model,
  }) async {
    final response = await _withRetry(
      () => _client
          .post(
            Uri.parse(OllamaConfig.chatUrl),
            headers: _headers,
            body: jsonEncode(
              _body(
                messages: messages,
                tools: tools,
                stream: false,
                model: model,
              ),
            ),
          )
          .timeout(_requestTimeout),
      onResponse: (response) => response.statusCode == 200
          ? null
          : OllamaException(
              _describeFailure(response.statusCode, response.body),
              statusCode: response.statusCode,
            ),
    );

    final decoded =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final message = (decoded['message'] as Map?)?.cast<String, dynamic>() ?? {};

    return OllamaChatResult(
      content: message['content'] as String? ?? '',
      toolCalls:
          (message['tool_calls'] as List?)
              ?.whereType<Map>()
              .map((call) => call.cast<String, dynamic>())
              .toList() ??
          const [],
    );
  }

  /// Streamed turn: Ollama replies with newline-delimited JSON objects.
  Stream<String> streamChat({
    required List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>>? tools,
    String? model,
  }) async* {
    // Retrying happens while opening the stream, before any token reached the
    // caller, so the user never sees duplicated text.
    final response = await _withRetry(
      () {
        final request = http.Request('POST', Uri.parse(OllamaConfig.chatUrl))
          ..headers.addAll(_headers)
          ..body = jsonEncode(
            _body(messages: messages, tools: tools, stream: true, model: model),
          );
        return _client.send(request).timeout(_requestTimeout);
      },
      onResponse: (response) async {
        if (response.statusCode == 200) return null;
        final body = await response.stream.bytesToString();
        return OllamaException(
          _describeFailure(response.statusCode, body),
          statusCode: response.statusCode,
        );
      },
    );

    final lines = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      Map<String, dynamic> payload;
      try {
        payload = jsonDecode(trimmed) as Map<String, dynamic>;
      } catch (_) {
        continue; // Partial or non-JSON keep-alive chunk.
      }

      if (payload['error'] != null) {
        throw OllamaException(payload['error'].toString());
      }

      final message = (payload['message'] as Map?)?.cast<String, dynamic>();
      final content = message?['content'] as String?;
      if (content != null && content.isNotEmpty) {
        yield content;
      }
    }
  }

  /// Runs [send] and retries transient failures with a small backoff.
  ///
  /// [onResponse] maps a completed response to an exception, so the status code
  /// is inspected before deciding whether another attempt makes sense.
  Future<T> _withRetry<T>(
    Future<T> Function() send, {
    required FutureOr<OllamaException?> Function(T response) onResponse,
  }) async {
    OllamaException? lastFailure;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      OllamaException failure;

      try {
        final response = await send();
        final rejected = await onResponse(response);
        if (rejected == null) return response;
        failure = rejected;
      } on OllamaException catch (error) {
        failure = error;
      } on TimeoutException {
        failure = const OllamaException('Ollama Cloud request timed out.');
      } catch (error) {
        failure = OllamaException('Ollama Cloud is unreachable: $error');
      }

      lastFailure = failure;
      if (!failure.isTransient || attempt == _maxAttempts) break;

      if (kDebugMode) {
        debugPrint(
          '[Ollama] attempt $attempt failed (${failure.message}), retrying',
        );
      }
      await Future<void>.delayed(_retryDelay * attempt);
    }

    throw lastFailure ?? const OllamaException('Ollama Cloud request failed.');
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${OllamaConfig.apiKey}',
  };

  Map<String, dynamic> _body({
    required List<Map<String, dynamic>> messages,
    required bool stream,
    List<Map<String, dynamic>>? tools,
    String? model,
  }) => {
    'model': model ?? OllamaConfig.model,
    'messages': messages,
    'stream': stream,
    if (tools != null && tools.isNotEmpty) 'tools': tools,
  };

  static String _describeFailure(int statusCode, String body) {
    if (statusCode == 401 || statusCode == 403) {
      return 'Ollama Cloud rejected the API key ($statusCode).';
    }
    if (statusCode == 429) {
      return 'Ollama Cloud rate limit reached ($statusCode). Try again shortly.';
    }
    final detail = body.trim();
    return 'Ollama Cloud returned $statusCode'
        '${detail.isEmpty ? '' : ': ${detail.substring(0, detail.length.clamp(0, 200))}'}';
  }

  @disposeMethod
  void dispose() => _client.close();
}
