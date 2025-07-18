import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

import 'package:camera_camera/camera_camera.dart';

Future<File?> openCamera(BuildContext context) async {
  final File? file = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CameraCamera(
        onFile: (File file) {
          Navigator.pop(context, file);
        },
      ),
    ),
  );
  return file;
}
