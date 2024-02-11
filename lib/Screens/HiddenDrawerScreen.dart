import 'package:flutter/material.dart';
import 'package:note/Custom/cusSnackBar.dart';
import 'package:note/Custom/cusText.dart';
import 'package:note/FirebaseAuth/FirebaseAuth.dart';
import 'package:note/Resources/DrawerItem.dart';
import 'package:note/Resources/Utils.dart';
import 'package:note/Screens/HomeScreen.dart';
import 'package:note/Screens/ProfileScreen.dart';
import 'package:note/Screens/SettingsScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class HiddenDrawerScreen extends StatefulWidget {
  const HiddenDrawerScreen({super.key});

  @override
  State<HiddenDrawerScreen> createState() => _HiddenDrawerScreenState();
}

class _HiddenDrawerScreenState extends State<HiddenDrawerScreen> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  late Widget screen = HomeScreen(openDrawer: openDrawer);
  int page = 0;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xOffset = 250;
      yOffset = 130;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          BuildDrawer(),
          BuildPage(),
        ],
      ),
    );
  }

  Widget BuildPage() {
    return PopScope(
      onPopInvoked: (s) {
        if (isDrawerOpen) {
          closeDrawer();
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 22 : 0),
              child: screen,
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildDrawer() {
    return SafeArea(
      child: Container(
        width: 210,
        child: Column(
          children: [
            Container(
              height: 100,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: drawerScreens.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(12),
                  decoration: page == index
                      ? BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12))
                      : BoxDecoration(),
                  child: ListTile(
                    onTap: () {
                      setState(() async {
                        switch (index) {
                          case 0:
                            page = 0;
                            screen = HomeScreen(openDrawer: openDrawer);
                            break;
                          case 1:
                            page = 1;
                            screen = ProfileScreen(openDrawer: openDrawer);
                            break;
                          case 2:
                            page = 2;
                            screen = SettingsScreen(openDrawer: openDrawer);
                            break;
                          case 3:
                            page = 3;
                            onUrlCall();
                            break;
                          case 4:
                            page = 4;
                            closeDrawer();
                            Future.delayed(const Duration(milliseconds: 500));
                            FirebaseAuthServices().logOut();
                            showCusSnackBar(
                                context, "Logged Out Successfully...");
                            Navigator.pushReplacementNamed(context, 'login');
                          default:
                            page = 0;
                            screen = HomeScreen(openDrawer: openDrawer);
                        }
                        closeDrawer();
                      });
                    },
                    leading: drawerIcons[index],
                    title: cusText(drawerScreens[index], 20, true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onUrlCall() async {
    final Uri url = Uri.parse(git_url);
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      showCusSnackBar(context, 'Error while opening web');
    }
  }
}
