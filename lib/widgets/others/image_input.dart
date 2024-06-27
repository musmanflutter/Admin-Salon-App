import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(Icons.upload),
      label: const Text('Upload'),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: screenSize.height * 0.3,
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      height: screenSize.height * 0.3,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
