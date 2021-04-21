import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Post extends StatefulWidget {
  final title = 'Wasteagram';
  static const routeName = 'gram_post';
  final File image;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Post({
    Key key,
    this.image,
    this.analytics,
    this.observer,
  }) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Future<void> _sendCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'gram_post',
      screenClassOverride: widget.title,
    );
  }

  final formKey = GlobalKey<FormState>();
  LocationData location;
  String imageURL;
  int items;

  void uploadImage() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(DateTime.now().toString());

    UploadTask uploadTask = storageReference.putFile(widget.image);
    var tempURL = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      imageURL = tempURL;
    });
  }

  void retrieveLocation() async {
    var locationService = Location();
    location = await locationService.getLocation();
  }

  void uploadGram() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      FirebaseFirestore.instance.collection('grams').add({
        'date': Timestamp.now(),
        'imageURL': imageURL,
        'items': items,
        'longitude': location.longitude.toDouble(),
        'latitude': location.latitude.toDouble(),
      });

      Navigator.of(context).pop();
    }
  }

  Widget itemsInputField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Semantics(
        enabled: true,
        textField: true,
        onTapHint: 'Enter number of wasted items',
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Number of Wasted Items',
          ),
          onSaved: (value) {
            items = int.parse(value);
          },
          validator: (value) {
            var temp = int.tryParse(value);
            if (value.isEmpty || temp == null) {
              return 'Please enter a number';
            } else if (temp < 1) {
              return 'Please enter at least 1 item';
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget uploadButton() {
    return Semantics(
      button: true,
      enabled: true,
      onTapHint: 'Upload gram',
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        child: ElevatedButton(
          child: Text(
            'Upload Gram',
            style: Theme.of(context).textTheme.headline6,
          ),
          onPressed: () {
            uploadGram();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveLocation();
    uploadImage();
  }

  @override
  Widget build(BuildContext context) {
    _sendCurrentScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              widget.image,
              width: 600,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Form(
              key: formKey,
              child: itemsInputField(context),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: uploadButton(),
            )
          ],
        ),
      ),
    );
  }
}
