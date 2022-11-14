import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:sleep_soundly/widgets/setting_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  _showMyDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SettingDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset(
        'assets/river.json',
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
