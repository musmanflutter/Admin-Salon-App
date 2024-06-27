import 'package:admin_app/models/service_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ServiceSlider extends StatefulWidget {
  const ServiceSlider({super.key, required this.serviceItems});
  final List<ServiceClass> serviceItems;

  @override
  State<ServiceSlider> createState() => _ServicesState();
}

class _ServicesState extends State<ServiceSlider> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.serviceItems.length,
          (index) => Column(
            children: [
              Container(
                height:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.11,
                width:
                    (screenSize.height - MediaQuery.of(context).padding.top) *
                        0.11,
                padding: EdgeInsets.all(screenSize.width * 0.01),
                margin: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.015,
                  vertical:
                      (screenSize.height - MediaQuery.of(context).padding.top) *
                          0.01,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.serviceItems[index].serviceImage,
                  fit: BoxFit.cover,
                  cacheManager: CacheManager(Config(
                    'customCacheKey',
                    stalePeriod: const Duration(days: 7),
                  )),

                  placeholder: (context, url) => const Center(
                      child:
                          CircularProgressIndicator()), // Placeholder until image is loaded
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Text(
                widget.serviceItems[index].serviceTitle,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
