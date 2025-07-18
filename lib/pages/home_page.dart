import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mosaico_fotos/custom/widgets/screenshot_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> imagesfiles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mosaico de Fotos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4B39EF),
      ),
      body: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Container do mosaico de fotos
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ScreenshotWidget(mosaico: imagesfiles),
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
