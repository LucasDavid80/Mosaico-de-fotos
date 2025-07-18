import 'dart:io';

import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  final File imageFile;
  const PreviewPage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(imageFile, fit: BoxFit.cover),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
