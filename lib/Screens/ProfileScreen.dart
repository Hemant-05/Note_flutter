import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/Custom/cusText.dart';
import 'package:note/Provider/UserProvider.dart';
import 'package:note/Resources/Utils.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.openDrawer});

  final VoidCallback openDrawer;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File file;
  bool status = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailsProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return value.model == null
            ? CircularProgressIndicator()
            : Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => widget.openDrawer(),
                  ),
                  title: cusText(value.model.name, 20, true),
                  centerTitle: true,
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => selectPick(value),
                        child: Container(
                          width: 300,
                          height: 400,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: status
                                ? Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    height: 300,
                                    child: CircularProgressIndicator(),
                                  )
                                : value.model.photoUrl!.isEmpty
                                    ? Container(
                                        color: Colors.grey,
                                        child: const Icon(
                                          Icons.person,
                                          size: 200,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            value.model.photoUrl.toString(),
                                      ),
                          ),
                        ),
                      ),
                      cusText(value.model.email ?? 'Not Fetch', 22, true),
                    ],
                  ),
                ),
              );
      },
    );
  }

  void selectPick(UserDetailsProvider provider) async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40).then(
      (value) {
        print('Enter to select pick');
        if (value != null) {
          file = File(value.path);
          String path = value.path.toString();
          uploadPicture('$path', provider);
          int size = file.lengthSync();
          print('$size');
        }
      },
    );
  }

  void uploadPicture(String fileName, UserDetailsProvider provider) async {
    setState(() {
      status = true;
    });
    var ref = FirebaseStorage.instance
        .ref()
        .child('profile photo')
        .child('$fileName.jpg');
    var uploadTask = await ref.putFile(file).catchError((e) {
      print('Some error');
      status = false;
    });
    if (status) {
      String picUrl = await uploadTask.ref.getDownloadURL();
      await _firestore.collection('users').doc(user?.uid).update(
        {
          'photoUrl': picUrl,
        },
      );
      provider.getUserDetails();
    }
    setState(() {
      status = false;
    });
  }
}
