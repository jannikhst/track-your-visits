import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_your_visits/login/authenticationscreen.dart';
import 'package:track_your_visits/models/user.dart';
import 'package:track_your_visits/system/database.dart';
import 'package:track_your_visits/view.dart';

class LoginWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return AuthenticationScreen();
    } else {
      User.id = user.uid;
      DatabaseService().fetchUser();
      return StreamProvider.value(value: DatabaseService().streamLastStores(),child: MainView());
    }
  }
}
