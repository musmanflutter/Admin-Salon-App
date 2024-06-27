import 'package:admin_app/models/deal_class.dart';
import 'package:admin_app/widgets/deals_screen/add_deal.dart';
import 'package:admin_app/widgets/deals_screen/deals_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:transparent_image/transparent_image.dart';

class DealScreenAvailable extends StatefulWidget {
  const DealScreenAvailable({super.key, required this.dealItems});
  final List<DealClass> dealItems;

  @override
  State<DealScreenAvailable> createState() => _DealScreenAvailableState();
}

class _DealScreenAvailableState extends State<DealScreenAvailable> {
  var isRemoving = false;
  void removeDeal(DealClass deal) async {
    setState(() {
      isRemoving = true;
    });
    await FirebaseFirestore.instance.collection('Deals').doc(deal.id).delete();
    await FirebaseStorage.instance
        .ref()
        .child('deals_images')
        .child('${deal.id}.jpg')
        .delete();

    setState(() {
      widget.dealItems.remove(deal);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Deal has been deleted'),
      ),
    );
    setState(() {
      isRemoving = false;
    });
  }

  void addNewDeal() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddDeal(),
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
            onPressed: addNewDeal,
            label: Text(
              'Add Deal',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        widget.dealItems.isEmpty
            ? SizedBox(
                height:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.59,
                child: Center(
                  child: Text(
                    'No Deals added  yet',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                ),
              )
            : DealsSlider(dealItems: widget.dealItems),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.dealItems.length,
            itemBuilder: (context, index) => Card(
              margin: EdgeInsets.only(
                bottom:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.02,
                top: (screenSize.height - MediaQuery.of(context).padding.top) *
                    0.01,
                left: screenSize.width * 0.01,
                right: screenSize.width * 0.01,
              ),
              color: const Color.fromARGB(255, 255, 239, 238),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3))),
              elevation: 2,
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: screenSize.height * 0.3,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                          // Placeholder image
                          MemoryImage(kTransparentImage),
                      image: CachedNetworkImageProvider(
                        widget.dealItems[index].dealImage,
                        cacheManager: CacheManager(Config(
                          'customCacheKey',
                          stalePeriod: const Duration(days: 7),
                        )),
                      ),

                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      // Optional parameters for customizing the fade-in effect
                      fadeOutCurve: Curves.easeOut,
                      fadeInCurve: Curves.easeIn,
                    ),
                    // child: CachedNetworkImage(
                    //   cacheManager: CacheManager(Config(
                    //     'customCacheKey',
                    //     stalePeriod: const Duration(days: 7),
                    //   )),
                    //   imageUrl: dealItems[index].dealImage,
                    //   fit: BoxFit.cover,
                    //   placeholder: (context, url) => const Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    //   errorWidget: (context, url, error) =>
                    //       const Icon(Icons.error),
                    // ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dealItems[index].dealTitle,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        SizedBox(
                          height: (screenSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.007,
                        ),
                        Text(
                          widget.dealItems[index].dealDescription,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: (screenSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.007,
                        ),
                        Text(
                          "Only: ${widget.dealItems[index].dealPrice} Rs",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: (screenSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          ),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              'Deal Delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            content: Text(
                              'Are you sure you want to delete this deal?',
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
                                  removeDeal(widget.dealItems[index]);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('DELETE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height:
              (screenSize.height - MediaQuery.of(context).padding.top) * 0.09,
        ),
      ],
    );
  }
}
