import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  late AssetsAudioPlayer assetsAudioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    assetsAudioPlayer.open(
      Audio("assets/music/sound.mp3"),
      autoStart: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              if (isPlaying) {
                assetsAudioPlayer.pause();
              } else {
                assetsAudioPlayer.play();
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
        ],
      ),
    );
  }
}
