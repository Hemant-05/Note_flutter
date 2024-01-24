import 'package:flutter/material.dart';
import 'package:note/Custom/custom_item.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: cusText('Settings',22,true),
      ),
      body: Container(
        alignment: Alignment.center,
        child: cusText('Work is On going \n Wait and support.',40, true),
      ),
    );
  }
}
