import 'package:admin_app/provider/load_specialist.dart';
import 'package:admin_app/widgets/others/build_error.dart';
import 'package:admin_app/widgets/others/build_loading.dart';
import 'package:admin_app/widgets/specialist_screen/specialists_available.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpecialistScreen extends ConsumerWidget {
  const SpecialistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final specialistAsyncValue = ref.watch(specialistProvider);
    return Consumer(
      builder: (context, ref, child) {
        return specialistAsyncValue.when(
          data: (data) {
            return SpecialistsAvailable(
              specialistItems: data,
            );
          },
          error: (error, stackTrace) => BuildError(error: error),
          loading: () => const BuildLoading(),
        );
      },
    );
  }
}
