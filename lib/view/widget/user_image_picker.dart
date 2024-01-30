import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onSelectedImage,
  });

  final void Function(File selectedImage) onSelectedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      // maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onSelectedImage(_pickedImageFile!);
  }

  void _pickImageGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      // maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onSelectedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            image: _pickedImageFile != null
                ? DecorationImage(
                    image: FileImage(_pickedImageFile!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: Color.fromRGBO(22, 35, 41, 1),
          ),
          child: _pickedImageFile == null
              ? const Icon(
                  Icons.add,
                  color: Colors.amber,
                )
              : null,
        ),
        TextButton(
          onPressed: () {
            _pickImage();
          },
          // icon: const Icon(Icons.camera_alt),
          child: const Text(
            'Take Image',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            _pickImageGallery();
          },
          // icon: const Icon(Icons.image),
          child: const Text(
            'Add Image',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
