import 'package:movies/core/services/apis/api_result.dart';

sealed class BaseViewState<T> {}

class LoadingState<T> extends BaseViewState<T> {
  String? message;

  LoadingState({this.message});
}

class ErrorState<T> extends BaseViewState<T> {
  ServerError? serverError;
  CodeError? codeError;

  ErrorState({this.serverError, this.codeError});
}

class SuccessState<T> extends BaseViewState<T> {
  T data;

  SuccessState({required this.data});
}
