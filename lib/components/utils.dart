import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? image = await _picker.pickImage(source: source);
  if (image != null) {
    return image.readAsBytes();
  } else {
    print('No image selected.');
  }
}
