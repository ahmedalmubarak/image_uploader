import 'package:bloc_fairebase_auth/bloc/app_bloc.dart';
import 'package:bloc_fairebase_auth/utils/dialogs/delete_account_dialog.dart';
import 'package:bloc_fairebase_auth/utils/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuActions { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();
    return PopupMenuButton<MenuActions>(
      onSelected: (value) async {
        switch (value) {
          case MenuActions.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              appBloc.add(const AppEventLogOut());
            }
            break;

          case MenuActions.deleteAccount:
            final shouldLogOut = await showDeleteAccountDialog(context);
            if (shouldLogOut) {
              appBloc.add(const AppEventDeleteAccount());
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuActions>(
            value: MenuActions.logout,
            child: Text('log out'),
          ),
          const PopupMenuItem<MenuActions>(
            value: MenuActions.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
