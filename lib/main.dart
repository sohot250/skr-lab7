import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lab7/widget/image_widget.dart';
import 'collection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.collections),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CollentionPage()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.amber.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Spacer(),
              image != null
                  ? ImageWidget(
                      image: image!, onClicked: (source) => pickImage(source))
                  : const FlutterLogo(size: 160),
              const SizedBox(height: 24),
              const Text(
                'Image Picker',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              buildButton(
                  title: 'Pick Gallery',
                  icon: Icons.image_outlined,
                  onClicked: () {
                    pickImage(ImageSource.gallery);
                  }),
              const SizedBox(height: 24),
              buildButton(
                  title: 'Pick Camera',
                  icon: Icons.camera_alt_outlined,
                  onClicked: () {
                    pickImage(ImageSource.camera);
                  }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    return ElevatedButton(
      onPressed: onClicked,
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(title)
        ],
      ),
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: const TextStyle(fontSize: 20)),
    );
  }
}
