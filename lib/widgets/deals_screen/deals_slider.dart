import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:admin_app/models/deal_class.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:transparent_image/transparent_image.dart';

class DealsSlider extends StatefulWidget {
  const DealsSlider({super.key, required this.dealItems});
  final List<DealClass> dealItems;

  @override
  State<DealsSlider> createState() => _DealsState();
}

class _DealsState extends State<DealsSlider> {
  @override
  void initState() {
    super.initState();
    // precacheImages(); // Precache images when the widget initializes
  }

  // Future<void> precacheImages() async {
  //   for (var deal in widget.dealItems) {
  //     // Cache each image using flutter_cache_manager
  //     await DefaultCacheManager().downloadFile(deal.dealImage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        CarouselSlider(
          items: widget.dealItems.map((deal) {
            return SizedBox(
              width: screenSize.width * 0.8,
              child: Card(
                // color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder:
                      // Placeholder image
                      MemoryImage(kTransparentImage),
                  image: CachedNetworkImageProvider(
                    deal.dealImage,
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
                //   // CachedNetworkImage(
                //   //   imageUrl: deal.dealImage,
                //   //   fit: BoxFit.cover,
                //   //   cacheManager: CacheManager(Config(
                //   //     'customCacheKey',
                //   //     stalePeriod: const Duration(days: 7),
                //   //   )),
                //   //   placeholder: (context, url) => const Center(
                //   //     child: CircularProgressIndicator(),
                //   //   ),
                //   //   errorWidget: (context, url, error) => const Icon(Icons.error),
                //   // ),
                // ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayInterval: const Duration(seconds: 2),
            onPageChanged: (index, reason) {},
          ),
        ),
      ],
    );
  }
}
