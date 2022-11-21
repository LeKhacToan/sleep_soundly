import 'dart:async';

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
  final int timerMaxSeconds = 60;
  int currentSeconds = 0;
  Timer? controlTime;

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

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout() {
    setState(() {
      controlTime = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();
            audioPlayer.pause();
          }
        });
      });
    });
  }

  Future<void> handleSelectSound(value) async {
    setState(() {
      item = value;
    });
    controlTime?.cancel();
    startTimeout();
    audioPlayer.pause();
    audioPlayer.setSourceAsset(item['mp3']);
    await audioPlayer.resume();
  }

  Future<void> controlPlayer() async {
    if (isPlaying) {
      audioPlayer.pause();
      controlTime?.cancel();
    } else {
      startTimeout();
      audioPlayer.setSourceAsset(item['mp3']);
      await audioPlayer.resume();
    }
  }

  showSettingDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SettingDialog(
              selectedId: item['id'], onSelect: handleSelectSound);
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  timerText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
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
