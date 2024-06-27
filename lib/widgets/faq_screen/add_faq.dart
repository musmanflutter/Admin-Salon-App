import 'package:admin_app/models/faq_class.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AddFaq extends StatefulWidget {
  const AddFaq({super.key});

  @override
  State<AddFaq> createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  final _form = GlobalKey<FormState>();
  var _enteredQuestion = '';
  var _enteredAnswer = '';
  var _isSaving = false;

  void _saveItem() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isSaving = true;
      });
      final faqCollection = FirebaseFirestore.instance.collection('Faqs');
      final doc = await faqCollection.add({
        'createAt': Timestamp.now(),
        'question': _enteredQuestion,
        'answer': _enteredAnswer,
      });

      final newItem = FaqClass(
          faqQuestion: _enteredQuestion, faqAnswer: _enteredAnswer, id: doc.id);
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
      title: const Text('Add Faq'),
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
                      maxLines: 2,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        label: Text('Question'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter a valid question';
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredQuestion = newValue!;
                      },
                    ),
                    TextFormField(
                      maxLines: 5,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        label: Text('Answer'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          return 'Please enter a valid Answer';
                        }

                        return null;
                      },
                      onSaved: (newValue) {
                        _enteredAnswer = newValue!;
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
                            child: const Text('Save Faq'),
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
