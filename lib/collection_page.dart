import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CollentionPage extends StatefulWidget {
  const CollentionPage({Key? key}) : super(key: key);

  @override
  State<CollentionPage> createState() => _CollentionPageState();
}

class _CollentionPageState extends State<CollentionPage> {
  final multiPicker = ImagePicker();
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Collection'),
        ),
        body: Column(
          children: [
            OutlinedButton(
                onPressed: () {
                  getMultiImages();
                },
                child: const Text('Select image')),
            Expanded(
              child: GridView.builder(
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(
                      //         color: Colors.grey.withOpacity(0.5))),
                      child: Stack(fit: StackFit.expand, children: [
                        images.isEmpty
                            ? Icon(
                                CupertinoIcons.camera,
                                color: Colors.grey.withOpacity(0.5),
                              )
                            : Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                              ),
                        //delete icon
                        Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              //color: Colors.grey[100],
                              child: IconButton(
                                onPressed: () {
                                  images.removeAt(index);
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red[500],
                              ),
                            ))
                      ]))),
            )
          ],
        ));
  }

  Future getMultiImages() async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage();
    setState(() {
      if (selectedImages!.isNotEmpty) {
        images.addAll(selectedImages);
      } else {
        print('No Images Selected ');
      }
    });
  }
}
