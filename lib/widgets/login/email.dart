import 'package:admin_app/widgets/login/prefix_icon.dart';
import 'package:flutter/material.dart';

class Email extends StatelessWidget {
  const Email({super.key, required this.onNameChange});
  final ValueChanged<String> onNameChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: PrefixIcon(icon: Icons.email_rounded),
        prefixIconConstraints: BoxConstraints.tightFor(width: 35),
      ),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      validator: (value) {
        if (value == null ||
            value.trim().isEmpty ||
            !value.contains('app.sohnasalon@gmail.com')) {
          return value == null || value.trim().isEmpty
              ? 'This field can\'t be empty.'
              : 'email doesn\'t match the admin\'s email.';
        }
        return null;
      },
      onChanged: onNameChange,
    );
  }
}
