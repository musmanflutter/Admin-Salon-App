import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/models/deal_class.dart';

import 'package:admin_app/widgets/others/image_input.dart';

class AddDeal extends StatefulWidget {
  const AddDeal({super.key});

  @override
  State<AddDeal> createState() => _AddDealState();
}

class _AddDealState extends State<AddDeal> {
  final _form = GlobalKey<FormState>();
  var _enteredTitle = '';
  var _enteredDecription = '';
  var _enteredPrice = '';
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
      final dealsCollection = FirebaseFirestore.instance.collection('Deals');
      final doc = await dealsCollection.add({
        'createAt': Timestamp.now(),
        'title': _enteredTitle,
        'description': _enteredDecription,
        'price': _enteredPrice,
      });
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('deals_images')
          .child('${doc.id}.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await doc.update({'imageUrl': imageUrl});

      final newItem = DealClass(
          dealImage: imageUrl,
          dealTitle: _enteredTitle,
          dealDescription: _enteredDecription,
          dealPrice: _enteredPrice,
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
      title: const Text('Add Deal'),
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
                    TextFormField(
                      maxLines: 3,
                      maxLength: 125,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        label: Text('Description'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter a valid Description';
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredDecription = newValue!;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: 'PKR: ',
                        label: Text('Price'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter a valid Price';
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredPrice = newValue!;
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
                            child: const Text('Save Deal'),
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
