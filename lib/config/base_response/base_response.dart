sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T? data) success,
    required R Function(String? errorMessage) error,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Error<T>) {
      return error((this as Error<T>).errorMessage);
    } else {
      return error("Unhandled ApiResult case");
    }
  }
}

class Success<T> extends Result<T> {
  final T? data;
  const Success({this.data});
}

class Error<T> extends Result<T> {
  final String? errorMessage;
  const Error({this.errorMessage});
}
