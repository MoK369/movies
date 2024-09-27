import 'dart:io';
import 'package:movies/core/services/apis/api_result.dart';

class ApiErrorMessage {
  static String getErrorMessage(
      {ServerError? serverError, CodeError? codeError}) {
    if (serverError != null) {
      return serverError.message;
    } else if (codeError != null) {
      var exception = codeError.exception;
      switch (exception) {
        case SocketException():
          return "No Internet connection 😑";
        case HttpException():
          return "Couldn't find the source 😱";
        case FormatException():
          return "Bad response format 👎";
        default:
          return "Something Went Wrong 🤔";
      }
    } else {
      return "Something Went Wrong 🤔";
    }
  }
}
