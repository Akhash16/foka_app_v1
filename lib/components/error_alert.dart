import 'package:flutter/material.dart';
import 'package:foka_app_v1/screens/login_screen.dart';

class ErrorAlert extends StatelessWidget {
  final String errorTitle;
  final String errorContent;
  final String route;

  const ErrorAlert({required this.errorTitle, required this.errorContent, required this.route});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(errorTitle),
      content: Text(errorContent),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName(LoginScreen.id)),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.popAndPushNamed(context, route),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
