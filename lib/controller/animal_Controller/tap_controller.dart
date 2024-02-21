import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MyController extends ChangeNotifier {
  ValueNotifier<bool> isAlgContainerVisible = ValueNotifier(false);
  var isIconVisible = true.obs;


  final ValueNotifier<bool> _languageChangedNotifier = ValueNotifier<bool>(false);

  final ValueNotifier<bool> refreshNotifier = ValueNotifier<bool>(false);

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
    refreshNotifier.value = !refreshNotifier.value;
    notifyListeners();
  }
}