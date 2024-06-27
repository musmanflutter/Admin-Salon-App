import 'package:admin_app/widgets/login/email.dart';
import 'package:admin_app/widgets/login/forgot_password.dart';
import 'package:admin_app/widgets/login/normal_signin_button.dart';
import 'package:admin_app/widgets/login/password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireBase = FirebaseAuth.instance;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    final messenger = ScaffoldMessenger.of(context);

    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _fireBase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
    } on FirebaseAuthException catch (error) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaObject = MediaQuery.of(context);
    final screenSize = mediaObject.size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: (screenSize.height - mediaObject.padding.top) * 0.02,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: (screenSize.height - mediaObject.padding.top) * 0.02,
        ),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Email(
                  onNameChange: (value) {
                    setState(() {
                      _enteredEmail = value;
                    });
                  },
                ),
                Password(
                  onNameChange: (value) {
                    setState(() {
                      _enteredPassword = value;
                    });
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.005,
                ),
                const ForgotPassword(),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                _isAuthenticating
                    ? const CircularProgressIndicator()
                    : NormalSignInButton(onPressed: _submit),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
