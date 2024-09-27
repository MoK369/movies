import 'package:intl/intl.dart';

extension StringExtensionMethods on String {
  String getUsDateFormat() {
    try {
      DateTime dateTime = DateFormat("yyyy-MM-dd").parse(this);
      DateFormat outputFormat = DateFormat("MMM dd, yyy");
      return outputFormat.format(dateTime);
    } on Exception {
      return this;
    }
  }
}
