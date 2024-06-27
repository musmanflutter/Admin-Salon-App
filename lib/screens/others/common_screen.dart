import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin_app/dummy.dart';
import 'package:admin_app/provider/selected_index.dart';
import 'package:admin_app/screens/common_screens/bookings_screen.dart';
import 'package:admin_app/screens/common_screens/deals_screen.dart';
import 'package:admin_app/screens/common_screens/faqs_screen.dart';
import 'package:admin_app/screens/common_screens/services_screen.dart';
import 'package:admin_app/screens/common_screens/specialist_screen.dart';
import 'package:admin_app/widgets/others/nav_bar.dart';

class CommonScreen extends ConsumerStatefulWidget {
  const CommonScreen({super.key});
  @override
  ConsumerState<CommonScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<CommonScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(indexProvider);
    final screenSize = MediaQuery.of(context).size;
    final appBar = AppBar(
      leading: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              content: Text(
                'Are you sure you want to logout?',
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    final poping = Navigator.of(context);

                    await FirebaseAuth.instance.signOut();

                    poping.pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout),
      ),
      toolbarHeight:
          (screenSize.height - MediaQuery.of(context).padding.top) * 0.1,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      centerTitle: true,
      title: Text(dummyIcons['labels']![selectedIndex]),
    );
    Widget? activeScreen;

    switch (selectedIndex) {
      case 0:
        activeScreen = const BookingScreen();
        break;
      case 1:
        activeScreen = const DealsScreen();
        break;
      case 2:
        activeScreen = const ServicesScreen();
        break;
      case 3:
        activeScreen = const SpecialistScreen();
        break;
      case 4:
        activeScreen = const FAQsScreen();
        break;
    }

    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop && selectedIndex != 0) {
          // If back navigation was canceled and not on home screen, navigate to home screen
          ref.read(indexProvider.notifier).updateIndex(0);
        }
      },
      child: Scaffold(
        appBar: appBar,
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
            ),
            Container(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.015,
                right: screenSize.width * 0.03,
                left: screenSize.width * 0.03,
              ),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: activeScreen,
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: NavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
