import 'package:flutter/material.dart';
import '../Custom/cusText.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.openDrawer});

  final VoidCallback openDrawer;

  @override
  Widget build(BuildContext context) {
    List dropdownList = [
      'Never','Daily','When I Tap'
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            openDrawer();
          },
        ),
        title: cusText('Settings', 22, true),
        centerTitle: true,
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ListTile(
                title: cusText('Notes Backup', 20, true),
                trailing : DropdownMenu(
                  onSelected: (value) {
                    print('Selected value is $value');
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'never do my notes backup', label: 'Never'),
                    DropdownMenuEntry(value: 150, label: 'Daily'),
                    DropdownMenuEntry(value: 250, label: 'When I Tap'),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
