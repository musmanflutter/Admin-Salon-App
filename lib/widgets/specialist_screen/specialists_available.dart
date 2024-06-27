import 'package:admin_app/models/specialist_class.dart';
import 'package:admin_app/widgets/specialist_screen/add_specialist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:transparent_image/transparent_image.dart';

class SpecialistsAvailable extends StatefulWidget {
  const SpecialistsAvailable({super.key, required this.specialistItems});
  final List<SpecialistClass> specialistItems;

  @override
  State<SpecialistsAvailable> createState() => _SpecialistsAvailableState();
}

class _SpecialistsAvailableState extends State<SpecialistsAvailable> {
  var isRemoving = false;
  void removeSpecialist(SpecialistClass specialist) async {
    setState(() {
      isRemoving = true;
    });
    await FirebaseFirestore.instance
        .collection('Specialists')
        .doc(specialist.id)
        .delete();
    await FirebaseStorage.instance
        .ref()
        .child('specialist_images')
        .child('${specialist.id}.jpg')
        .delete();

    setState(() {
      widget.specialistItems.remove(specialist);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Specialist has been deleted'),
      ),
    );
    setState(() {
      isRemoving = false;
    });
  }

  void addNewSpecialist() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddSpecialist(),
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
            onPressed: addNewSpecialist,
            label: Text(
              'Add Specialist',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        widget.specialistItems.isEmpty
            ? SizedBox(
                height:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.59,
                child: Center(
                  child: Text(
                    'No specialists added  yet',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                ),
              )
            : SizedBox(
                height:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.35,
                child: ListView.builder(
                  itemCount: widget.specialistItems.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        height: (screenSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.35,
                        width: screenSize.width * 0.44,
                        margin: EdgeInsets.only(
                          left: screenSize.width * 0.015,
                          right: screenSize.width * 0.015,
                          top: (screenSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.022,
                          bottom: (screenSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.01,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder:
                              // Placeholder image
                              MemoryImage(kTransparentImage),
                          image: CachedNetworkImageProvider(
                            widget.specialistItems[index].specialistImage,
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
                        // CachedNetworkImage(
                        //   fit: BoxFit.cover,
                        //   imageUrl: specialistItems[index].specialistImage,
                        //   cacheManager: CacheManager(Config(
                        //     'customCacheKey',
                        //     stalePeriod: const Duration(days: 7),
                        //   )),
                        //   placeholder: (context, url) => const Center(
                        //     child: CircularProgressIndicator(),
                        //   ),
                        //   errorWidget: (context, url, error) =>
                        //       const Icon(Icons.error),
                        // ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.6),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(15),
                            ),
                          ),
                          height: (screenSize.height -
                                  MediaQuery.of(context).padding.top) *
                              0.05,
                          width: screenSize.width * 0.44,
                          margin: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.015,
                            vertical: (screenSize.height -
                                    MediaQuery.of(context).padding.top) *
                                0.01,
                          ),
                          child: Text(
                            widget.specialistItems[index].specialistTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  'Specialist Delete',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this specialist?',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    onPressed: () async {
                                      removeSpecialist(
                                          widget.specialistItems[index]);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
