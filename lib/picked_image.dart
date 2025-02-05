import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickedImage extends StatefulWidget {
  const PickedImage({super.key});

  @override
  State<PickedImage> createState() => _PickedImageState();
}

class _PickedImageState extends State<PickedImage> {
  List<File> images = [];
  final ImagePicker imagePicker = ImagePicker();

  Future<void> pickImages() async {
    var status = await Permission.photos.request(); // Request permission

    if (status.isGranted) {
      // If permission is granted, pick images
      final List<XFile>? pickedFiles = await imagePicker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          images = pickedFiles.map((file) => File(file.path)).toList();
        });
      }
    } else if (status.isDenied) {
      // If permission is denied, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gallery access is required to pick images")),
      );
    } else if (status.isPermanentlyDenied) {
      // If permission is permanently denied, open settings
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Pick Your Images",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 0, 162),
              fontSize: 30,
              fontWeight: FontWeight.w300),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          Expanded(
              child: images.isNotEmpty
                  ? ListView.builder(
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.file(images[index]),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No images selected",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: pickImages,
              style: FilledButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 0, 162),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
              child: Text("Pick Image"),
            ),
          )
        ],
      ),
    );
  }
}
