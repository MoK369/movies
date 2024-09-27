import 'package:flutter/material.dart';

class BrowsePageViewModel extends ChangeNotifier {
  void refreshForChanges() {
    notifyListeners();
  }
}
