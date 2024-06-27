import 'package:admin_app/models/service_class.dart';
import 'package:admin_app/widgets/services_screen/add_service.dart';
import 'package:admin_app/widgets/services_screen/service_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:transparent_image/transparent_image.dart';

class ServicesScreenAvailable extends StatefulWidget {
  const ServicesScreenAvailable({super.key, required this.serviceItems});
  final List<ServiceClass> serviceItems;

  @override
  State<ServicesScreenAvailable> createState() =>
      _ServicesScreenAvailableState();
}

class _ServicesScreenAvailableState extends State<ServicesScreenAvailable> {
  var isRemoving = false;
  void removeService(ServiceClass service) async {
    setState(() {
      isRemoving = true;
    });
    await FirebaseFirestore.instance
        .collection('Services')
        .doc(service.id)
        .delete();
    await FirebaseStorage.instance
        .ref()
        .child('services_images')
        .child('${service.id}.jpg')
        .delete();

    setState(() {
      widget.serviceItems.remove(service);
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Service has been deleted'),
      ),
    );
    setState(() {
      isRemoving = true;
    });
  }

  void addNewService() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddService(),
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
            onPressed: addNewService,
            label: Text(
              'Add Service',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        widget.serviceItems.isEmpty
            ? SizedBox(
                height:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.59,
                child: Center(
                  child: Text(
                    'No Services added  yet',
                    style: Theme.of(context).textTheme.titleLarge!,
                  ),
                ),
              )
            : ServiceSlider(serviceItems: widget.serviceItems),
        Divider(
          color: Theme.of(context).colorScheme.primary,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.serviceItems.length,
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
                    padding: EdgeInsets.only(top: screenSize.width * 0.02),
                    height: screenSize.height * 0.3,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                          // Placeholder image
                          MemoryImage(kTransparentImage),
                      image: CachedNetworkImageProvider(
                        widget.serviceItems[index].serviceImage,
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
                    //   imageUrl: serviceItems[index].serviceImage,
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
                          widget.serviceItems[index].serviceTitle,
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
                          widget.serviceItems[index].serviceDescription,
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
                          "Starting from: ${widget.serviceItems[index].servicePrice} Rs",
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
                              'Service Delete',
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
                              'Are you sure you want to delete this service?',
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
                                  removeService(widget.serviceItems[index]);
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
