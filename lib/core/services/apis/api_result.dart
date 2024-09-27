sealed class ApiResult<T> {}

class Success<T> extends ApiResult<T> {
  T data;

  Success({required this.data});
}

class ServerError<T> extends ApiResult<T> {
  num code;
  String message;

  ServerError({required this.code, required this.message});
}

class CodeError<T> extends ApiResult<T> {
  Exception exception;

  CodeError({required this.exception});
}
