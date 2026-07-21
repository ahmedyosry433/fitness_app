import 'package:equatable/equatable.dart';

enum StateType { initial, loading, moreLoading, success, error }

// changed from abstract class to class to make it possible to be initialized
class BaseState<T> extends Equatable {
  final StateType? state;
  final T? data;
  final String? errorMessage;

  const BaseState({
    this.state = StateType.initial,
    this.data,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [state, data, errorMessage];

  const BaseState.initial()
    : state = StateType.initial,
      data = null,
      errorMessage = null;

  const BaseState.loading()
    : state = StateType.loading,
      data = null,
      errorMessage = null;

  const BaseState.success(this.data)
    : state = StateType.success,
      errorMessage = null;

  const BaseState.error(this.errorMessage)
    : state = StateType.error,
      data = null;
  const BaseState.all({
    required this.errorMessage,
    required this.data,
    required this.state,
  });

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
    return 'BaseState(state:$state,${data != null ? ',data: $data, ' : ''}${errorMessage != null ? ',exception: $errorMessage' : ''})';
  }
}
