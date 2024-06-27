import 'package:admin_app/provider/load_service.dart';
import 'package:admin_app/widgets/others/build_error.dart';
import 'package:admin_app/widgets/others/build_loading.dart';
import 'package:admin_app/widgets/services_screen/services_screen_available.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsyncValue = ref.watch(serviceProvider);

    return Consumer(
      builder: (context, ref, child) {
        return serviceAsyncValue.when(
          data: (data) {
            return ServicesScreenAvailable(
              serviceItems: data,
            );
          },
          error: (error, stackTrace) => BuildError(error: error),
          loading: () => const BuildLoading(),
        );
      },
    );
  }
}
