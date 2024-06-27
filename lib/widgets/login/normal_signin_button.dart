import 'package:flutter/material.dart';

class NormalSignInButton extends StatelessWidget {
  const NormalSignInButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.32,
            vertical: screenSize.height * 0.02),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: Text(
        'Sign In',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: screenSize.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
