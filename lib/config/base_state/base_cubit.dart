import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Base cubit that adds a one-shot UI event stream on top of bloc state.
/// State is for rebuildable UI; events are for side effects such as navigation
/// or toasts (things you do once, not store in state).
abstract class BaseCubit<State, UiEvent> extends Cubit<State> {
  BaseCubit(super.initialState);

  final StreamController<UiEvent> _eventController =
      StreamController<UiEvent>.broadcast();

  Stream<UiEvent> get eventStream => _eventController.stream;

  /// Alias for eventStream used in navigation contexts.
  Stream<UiEvent> get navigationStream => _eventController.stream;

  void emitEvent(UiEvent event) {
    if (_eventController.isClosed) return;
    _eventController.add(event);
  }

  /// Alias for emitEvent used in navigation contexts.
  void doNavigationAction(UiEvent event) => emitEvent(event);

  /// Optional method for processing intent/events.
  Future<void> doAction(covariant dynamic event) async {}

  @override
  Future<void> close() async {
    await _eventController.close();
    return super.close();
  }
}
