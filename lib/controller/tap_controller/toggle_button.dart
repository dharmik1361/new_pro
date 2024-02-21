import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isSettingsVisible = false.obs;
  var settingImageAsset = "assets/Setting/Setting .png".obs;
  var isSoundPlaying = true.obs;

  void toggleSettingsVisibility() {
    isSettingsVisible.value = !isSettingsVisible.value;
    settingImageAsset.value = isSettingsVisible.value
        ? "assets/Setting/Setting Off.png"
        : "assets/Setting/Setting .png";
  }

  void toggleSound() {
    isSoundPlaying.value = !isSoundPlaying.value;

  }

}

