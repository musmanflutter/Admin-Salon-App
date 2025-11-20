import 'package:admin_app/models/order_class.dart';
import 'package:admin_app/provider/load_orders.dart';
import 'package:admin_app/widgets/others/booked_screen_available.dart';
import 'package:admin_app/widgets/others/build_error.dart';
import 'package:admin_app/widgets/others/build_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String _currentFilter = "ALL"; // default filter
  bool _descending = true; // default future → past

  @override
  Widget build(BuildContext context) {
    final appointmentsAsyncValue = ref.watch(orderProvider);

    return appointmentsAsyncValue.when(
      data: (data) {
        // Apply filters + sorting to your orders
        final filtered = _applyFilter(data, _currentFilter);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Bookings"),

            actions: [
              IconButton(
                icon: Icon(
                  _descending
                      ? Icons.south
                      : Icons.north, // ↓ for descending, ↑ for ascending
                ),
                tooltip: _descending ? "Future → Past" : "Past → Future",
                onPressed: () {
                  setState(() => _descending = !_descending);
                },
              ),

              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                onSelected: (value) {
                  setState(() => _currentFilter = value);
                },
                itemBuilder: (context) => [
                  _menuItem("ALL"),
                  _menuItem("TODAY"),
                  _menuItem("PAST WEEK"),
                  _menuItem("PAST MONTH"),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    "Total: ${filtered.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          body: BookedScreenAvailable(orderItems: filtered),
        );
      },
      error: (error, _) => BuildError(error: error.toString()),
      loading: () => const BuildLoading(),
    );
  }

  /// Popup item with checkmark on selected filter
  PopupMenuItem<String> _menuItem(String label) {
    return PopupMenuItem(
      value: label,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (_currentFilter == label) const Icon(Icons.check, size: 18),
        ],
      ),
    );
  }

  /// Filtering + Sorting Function
  List<OrderClass> _applyFilter(List<OrderClass> list, String filter) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    List<OrderClass> filtered = list;

    if (filter == "TODAY") {
      filtered = list.where((order) {
        DateTime d = order.date.toDate();
        return d.year == todayStart.year &&
            d.month == todayStart.month &&
            d.day == todayStart.day;
      }).toList();
    } else if (filter == "PAST WEEK") {
      final weekAgo = now.subtract(const Duration(days: 7));
      filtered = list.where((order) {
        return order.date.toDate().isAfter(weekAgo);
      }).toList();
    } else if (filter == "PAST MONTH") {
      final monthAgo = now.subtract(const Duration(days: 30));
      filtered = list.where((order) {
        return order.date.toDate().isAfter(monthAgo);
      }).toList();
    }

    // Sorting (Future → Past)
    // Sorting logic with toggle
    if (_descending) {
      // Future → Past (default)
      filtered.sort((a, b) {
        return b.date.toDate().compareTo(a.date.toDate());
      });
    } else {
      // Past → Future (reverse)
      filtered.sort((a, b) {
        return a.date.toDate().compareTo(b.date.toDate());
      });
    }

    return filtered;
  }
}
