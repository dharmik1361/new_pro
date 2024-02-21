import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class AudioController extends GetxController {
  late AssetsAudioPlayer _assetsAudioPlayer;
  var isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(
      Audio("assets/music/gameappsound.mp3"),
      loopMode: LoopMode.single,
    );
    _assetsAudioPlayer.isPlaying.listen((event) {
      isPlaying.value = event;
    });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      _assetsAudioPlayer.pause();
    } else {
      _assetsAudioPlayer.play();
    }
  }

  @override
  void onClose() {
    _assetsAudioPlayer.dispose();
    super.onClose();
  }
}
