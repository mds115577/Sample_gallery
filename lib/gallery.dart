// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_sample/screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List> database = ValueNotifier([]);

class Photos extends StatelessWidget {
  const Photos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 39) / 2;
    final double itemWidth = size.width / 1.6;

    return Scaffold(
      backgroundColor: const Color.fromARGB(173, 255, 255, 255),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Photos'),
        backgroundColor: const Color.fromARGB(255, 4, 4, 4),
      ),
      body: ValueListenableBuilder(
        valueListenable: database,
        builder: (context, List data, anything) {
          return Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 3,
                mainAxisSpacing: 4,
                childAspectRatio: (itemWidth / itemHeight),
              ),
              children: List.generate(
                data.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ScreenImg(
                            image: data[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: FileImage(
                            File(
                              data[index].toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          buttonClick();
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}

void buttonClick() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);
  if (image == null) {
    return;
  } else {
    Directory? directory = await getExternalStorageDirectory();
    File imagepath = File(image.path);

    await imagepath.copy('${directory!.path}/${DateTime.now()}.jpg');

    getitems(directory);
  }
}

getitems(Directory directory) async {
  final listDir = await directory.list().toList();
  database.value.clear();
  for (var i = 0; i < listDir.length; i++) {
    if (listDir[i].path.substring(
            (listDir[i].path.length - 4), (listDir[i].path.length)) ==
        '.jpg') {
      database.value.add(listDir[i].path);
      database.notifyListeners();
    }
  }
}
