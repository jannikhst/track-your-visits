import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:track_your_visits/login/login_provider.dart';
import 'package:track_your_visits/system/authenticator.dart';

void main() {
  // initializeDateFormatting("de_DE", null);
  // findSystemLocale().then((v) {
  //   Intl.defaultLocale = v;
  // });
  runApp(MyApp());
}

//TODO: terminal: 'flutter run flutter_launcher_icons:main' to set app icon

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(providers: [
      StreamProvider<FirebaseUser>.value(value: Authenticator().userStream),
    ], child: LoginProvider());
  }
}
