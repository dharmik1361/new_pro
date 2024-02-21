import 'package:flutter/material.dart';
class MyController extends ChangeNotifier {
  ValueNotifier<bool> isAlgContainerVisible = ValueNotifier(false);
  ValueNotifier<bool> isIconVisible = ValueNotifier(false);


  final ValueNotifier<bool> _languageChangedNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _refreshNotifier = ValueNotifier<bool>(false);

  ValueNotifier<bool> get refresshNotifier => _refreshNotifier;

  ValueNotifier<bool> get languageChangedNotifier => _languageChangedNotifier;

  void notifyLanguageChanged() {
    _languageChangedNotifier.value = !_languageChangedNotifier.value;
  }
  void toggleIconVisibility() {
    isIconVisible.value = !isIconVisible.value;
  }
  void toggleVisibility() {
    isAlgContainerVisible.value = !isAlgContainerVisible.value;
    notifyListeners();
  }

  void toggletherefresh() {
  _refreshNotifier.value = !_refreshNotifier.value;
  }
}