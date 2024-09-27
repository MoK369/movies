extension NumExtensionMethods on num {
  String getTimeFormatFromNumberOfMinutes() {
    num input = this;
    num hours = input ~/ 60;
    num minutes = input % 60;
    return "${hours}h ${minutes}m";
  }
}
