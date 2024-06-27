import 'package:admin_app/provider/load_deal.dart';
import 'package:admin_app/widgets/deals_screen/deal_screen_available.dart';
import 'package:admin_app/widgets/others/build_error.dart';
import 'package:admin_app/widgets/others/build_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DealsScreen extends ConsumerWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsyncValue = ref.watch(dealsProvider);

    return Consumer(
      builder: (context, ref, child) {
        return dealsAsyncValue.when(
          data: (data) {
            return DealScreenAvailable(
              dealItems: data,
            );
          },
          error: (error, stackTrace) => BuildError(error: error),
          loading: () => const BuildLoading(),
        );
      },
    );
  }
}
