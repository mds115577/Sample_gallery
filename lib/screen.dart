import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_sample/gallery.dart';

class ScreenImg extends StatelessWidget {
  const ScreenImg({Key? key, this.image}) : super(key: key);
  final dynamic image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 201, 201),
      body: ValueListenableBuilder(
          valueListenable: database,
          builder: (context, List data, _) {
            return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Image.file(File(image.toString())),
                ));
          }),
    );
  }
}
