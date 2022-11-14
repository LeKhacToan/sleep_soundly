import 'package:flutter/cupertino.dart';
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
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> handleSelectSound(value) async {
    setState(() {
      item = value;
    });
    audioPlayer.pause();
    audioPlayer.setSourceAsset(item['mp3']);
    await audioPlayer.resume();
  }

  Future<void> controlPlayer() async {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.setSourceAsset(item['mp3']);
      await audioPlayer.resume();
    }
  }

  showSettingDialog() {
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'play',
                onPressed: controlPlayer,
                tooltip: 'Setting',
                backgroundColor: Colors.white,
                child: Icon(
                  isPlaying
                      ? CupertinoIcons.pause_fill
                      : CupertinoIcons.play_arrow_solid,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'seting',
                onPressed: showSettingDialog,
                tooltip: 'Setting',
                child: const Icon(Icons.settings),
              ),
            ],
          )
        ],
      ),
    );
  }
}
