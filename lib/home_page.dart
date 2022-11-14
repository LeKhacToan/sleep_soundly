import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:sleep_soundly/widgets/setting_dialog.dart';
import 'package:sleep_soundly/utils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Map<String, dynamic> item = kMedia[0];
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    playAudio();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void handleSelectSound(value) {
    setState(() {
      item = value;
    });
    playAudio();
  }

  Future playAudio() async {
    audioPlayer.pause();
    audioPlayer.setSourceAsset(item['mp3']);
    await audioPlayer.resume();
  }

  _showMyDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SettingDialog(onSelect: handleSelectSound);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: item['is_image']
          ? Image.asset(
              item['background'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : Lottie.asset(
              item['background'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMyDialog,
        tooltip: 'Setting',
        child: const Icon(Icons.settings),
      ),
    );
  }
}
