sealed class BaseEvent {
  const BaseEvent();
}

class ShowSuccessToastEvent extends BaseEvent {
  final String message;
  const ShowSuccessToastEvent(this.message);
}

class ShowErrorToastEvent extends BaseEvent {
  final String message;
  const ShowErrorToastEvent(this.message);
}

class NavigateEvent extends BaseEvent {
  final String routeName;
  final Object? extra;

  const NavigateEvent({required this.routeName, this.extra});
}
