import 'package:flutter/foundation.dart';
import 'package:movies/core/bases/base_view_state.dart';

class BaseViewModel<T> extends ChangeNotifier {
  BaseViewState<T> viewState;

  BaseViewModel({required this.viewState});

  void refreshWithState(BaseViewState<T> newState) {
    viewState = newState;
    notifyListeners();
  }
}
