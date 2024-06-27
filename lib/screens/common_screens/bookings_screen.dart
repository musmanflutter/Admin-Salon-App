import 'package:admin_app/provider/load_orders.dart';
import 'package:admin_app/widgets/others/booked_screen_available.dart';
import 'package:admin_app/widgets/others/build_error.dart';
import 'package:admin_app/widgets/others/build_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingScreen extends ConsumerWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsyncValue = ref.watch(orderProvider);

    return Consumer(
      builder: (context, ref, child) {
        return appointmentsAsyncValue.when(
          data: (data) {
            return BookedScreenAvailable(orderItems: data);
          },
          error: (error, stackTrace) => BuildError(error: error.toString()),
          loading: () => const BuildLoading(),
        );
      },
    );
  }
}
