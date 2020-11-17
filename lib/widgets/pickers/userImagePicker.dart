import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) handlePickedImage;

  UserImagePicker({this.handlePickedImage});
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _storedImage; // ds holds d selected image from device

  // ds method will open d gallery for us to select an image
  _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        // a value btw 0 to 100
        imageQuality: 50,
        maxWidth: 150);
    setState(() {
      _storedImage = imageFile;
    });
    // we pass the picked image to our defined function handler dt will trigger the function to upload it in authForm.dart file
    widget.handlePickedImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _storedImage != null ? FileImage(_storedImage) : null,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
            icon: Icon(Icons.image),
            label: Text("Add Image"))
      ],
    );
  }
}
