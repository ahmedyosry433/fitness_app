sealed class BaseEvent {
  const BaseEvent();
}

class DisplayError extends BaseEvent {
  final String message;
  const DisplayError(this.message);
}

class DisplaySuccess extends BaseEvent {
  final String message;
  const DisplaySuccess(this.message);
}

class NavigateEvent extends BaseEvent {
  final String routeName;
  final Object? extra;

  const NavigateEvent({required this.routeName, this.extra});
}