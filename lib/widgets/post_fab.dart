import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasteagram/screens/post.dart';

class PostFAB extends StatefulWidget {
  @override
  _PostFABState createState() => _PostFABState();
}

class _PostFABState extends State<PostFAB> {
  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      } else {
        print('No image selected');
      }
    });
  }

  void pushPostScreen(BuildContext context) async {
    await getImage();
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Post(image: image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      onTapHint: 'Select an image',
      child: FloatingActionButton(
        onPressed: () {
          pushPostScreen(context);
        },
        tooltip: 'Select Photo',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
