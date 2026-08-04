import 'package:equatable/equatable.dart';

enum StateType { initial, loading, moreLoading, success, error }

class BaseState<T> extends Equatable {
  final StateType? state;
  final T? data;
  final String? errorMessage;
  final dynamic _exception;

  dynamic get exception => _exception ?? errorMessage;
  const BaseState({
    this.state = StateType.initial,
    this.data,
    this.errorMessage,
    dynamic exception,
  }) : _exception = exception;
  @override
  List<Object?> get props => [state, data, errorMessage, _exception];

  const BaseState.initial()
      : state = StateType.initial,
        data = null,
        errorMessage = null,
        _exception = null;

  const BaseState.loading()
      : state = StateType.loading,
        data = null,
        errorMessage = null,
        _exception = null;

  const BaseState.success(this.data)
      : state = StateType.success,
        errorMessage = null,
        _exception = null;

  BaseState.error(dynamic error)
      : state = StateType.error,
        data = null,
        errorMessage = error is String ? error : error?.toString(),
        _exception = error;

  BaseState.all({
    required this.state,
    required this.data,
    String? errorMessage,
    dynamic exception,
  })  : errorMessage = errorMessage ?? exception?.toString(),
        _exception = exception ?? errorMessage;

  bool get isInitial => state == StateType.initial;
  bool get isLoading => state == StateType.loading;
  bool get isMoreLoading => state == StateType.moreLoading;
  bool get isSuccess => state == StateType.success;
  bool get isError => state == StateType.error;
  // added when method to make the code more readable in the UI
  R when<R>({
    required R Function(T data) success,
    required R Function() loading,
    R Function()? moreLoading,
    required R Function(String errorMessage) error,
    required R Function() initial,
  }) {
    return switch (state ?? StateType.initial) {
      StateType.initial => initial(),
      StateType.loading => loading(),
      StateType.moreLoading => moreLoading != null ? moreLoading() : loading(),
      StateType.success => success(data as T),
      StateType.error => error(errorMessage ?? "An unexpected error occurred"),
    };
  }

  @override
  String toString() {
    return 'BaseState(state:$state,${data != null ? ',data: $data, ' : ''}${errorMessage != null ? ',errorMessage: $errorMessage' : ''}${_exception != null ? ',exception: $_exception' : ''})';
  }
}
