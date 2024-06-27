import 'package:admin_app/models/faq_class.dart';
import 'package:admin_app/widgets/faq_screen/add_faq.dart';
import 'package:admin_app/widgets/faq_screen/list_faq.dart';
import 'package:flutter/material.dart';

class FaqScreenAvailable extends StatefulWidget {
  const FaqScreenAvailable({super.key, required this.faqItems});
  final List<FaqClass> faqItems;

  @override
  State<FaqScreenAvailable> createState() => _FaqScreenAvailableState();
}

class _FaqScreenAvailableState extends State<FaqScreenAvailable> {
  void addNewFaq() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddFaq(),
      ),
    );
    if (newItem == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: screenSize.height * 0.08,
          margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: addNewFaq,
            label: Text(
              'Add Faq',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        widget.faqItems.isEmpty
            ? SizedBox(
                height:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.59,
                child: Center(
                  child: Text(
                    'No Faqs added  yet',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                ),
              )
            : Expanded(child: ListFaq(faqItems: widget.faqItems)),
         SizedBox(
          height:
              (screenSize.height - MediaQuery.of(context).padding.top) * 0.09,
        ),

      ],
    );
  }
}
