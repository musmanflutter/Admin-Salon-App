import 'package:admin_app/models/faq_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListFaq extends StatefulWidget {
  final List<FaqClass> faqItems;

  const ListFaq({
    required this.faqItems,
    super.key,
  });

  @override
  State<ListFaq> createState() => _ListFaqState();
}

class _ListFaqState extends State<ListFaq> {
  var isRemoving = false;
  void removeFaq(FaqClass faq) async {
    setState(() {
      isRemoving = true;
    });
    await FirebaseFirestore.instance.collection('Faqs').doc(faq.id).delete();

    setState(() {
      widget.faqItems.remove(faq);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Faq has been deleted'),
      ),
    );
    setState(() {
      isRemoving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ListView.builder(
      itemCount: widget.faqItems.length,
      itemBuilder: (context, index) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: (screenSize.height - MediaQuery.of(context).padding.top) *
                  0.02,
            ),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: ExpansionTile(
                  collapsedIconColor: Theme.of(context).colorScheme.primary,
                  tilePadding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  childrenPadding:
                      EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  title: Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    widget.faqItems[index].faqQuestion,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  children: [
                    Text(
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      widget.faqItems[index].faqAnswer,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      'Faq Delete',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    content: Text(
                      'Are you sure you want to delete this Faq?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () async {
                          removeFaq(widget.faqItems[index]);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
