import 'package:bloc_fairebase_auth/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are your sure you want to out?',
    optionsBuilder: () => {
      'Cancel': false,
      'log out': true,
    },
  ).then((value) => value ?? false);
}
