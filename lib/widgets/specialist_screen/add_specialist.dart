import 'dart:io';

import 'package:admin_app/models/specialist_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:admin_app/widgets/others/image_input.dart';

class AddSpecialist extends StatefulWidget {
  const AddSpecialist({super.key});

  @override
  State<AddSpecialist> createState() => _AddSpecialistState();
}

class _AddSpecialistState extends State<AddSpecialist> {
  final _form = GlobalKey<FormState>();
  var _enteredTitle = '';
  File? _selectedImage;
  var _isSaving = false;

  void _saveItem() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _selectedImage == null) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isSaving = true;
      });
      final specialistCollection =
          FirebaseFirestore.instance.collection('Specialists');
      final doc = await specialistCollection.add({
        'createAt': Timestamp.now(),
        'title': _enteredTitle,
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('specialist_images')
          .child('${doc.id}.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await doc.update({'imageUrl': imageUrl});

      final newItem = SpecialistClass(
          specialistImage: imageUrl,
          specialistTitle: _enteredTitle,
          id: doc.id);
      if (!mounted) return;
      Navigator.of(context).pop(newItem);
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final appBar = AppBar(
      toolbarHeight:
          (screenSize.height - MediaQuery.of(context).padding.top) * 0.1,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      centerTitle: true,
      title: const Text('Add Specialist'),
    );
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: screenSize.height * 0.03,
              right: screenSize.width * 0.03,
              left: screenSize.width * 0.03,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 11,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter a valid title';
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredTitle = newValue!.toUpperCase();
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    ImageInput(
                      onPickImage: (image) {
                        _selectedImage = image;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.02,
                    ),
                    _isSaving
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: _saveItem,
                            child: const Text('Save Specialist'),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
