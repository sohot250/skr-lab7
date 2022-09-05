import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatelessWidget {
  final File image;
  final ValueChanged<ImageSource> onClicked;

  const ImageWidget({Key? key, required this.image, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(context),
          Positioned(child: buildEditIcon(), bottom: 0, right: 4)
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    final imagePath = this.image.path;
    final image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return ClipOval(
        child: Material(
            color: Colors.transparent,
            child: Ink.image(
                image: image as ImageProvider,
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                child: InkWell(onTap: () async {
                  final source = await showImageSource(context);
                  if (source == null) return;

                  onClicked(source);
                }))));
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    child: const Text('Camera'),
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.camera),
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Gallery'),
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.gallery),
                  )
                ],
              ));
    } else {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Camera'),
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.camera)),
                  ListTile(
                      leading: const Icon(Icons.image),
                      title: const Text('Gallery'),
                      onTap: () =>
                          Navigator.of(context).pop(ImageSource.gallery))
                ],
              ));
    }
  }

  Widget buildEditIcon() {
    return const ClipOval(
      child: Material(
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.add_a_photo, color: Colors.white, size: 40),
          )),
    );
  }
}
