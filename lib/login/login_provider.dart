import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:flutter/material.dart';
import 'package:track_your_visits/login/login_wrapper.dart';
import 'package:track_your_visits/login/register.dart';
import 'package:track_your_visits/login/set_user_data.dart';
import 'package:track_your_visits/login/signin.dart';

class LoginProvider extends StatefulWidget {
  @override
  _LoginProviderState createState() => _LoginProviderState();
}

class _LoginProviderState extends State<LoginProvider> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'track your visits',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.deepPurpleAccent,
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ))),
      routes: {
        // '/': (ctx) => CustomTabBar(fl: fl, user: user),
        // '/': (ctx) => TabViewer(user: user),
        '/': (ctx) => LoginWrapper(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        SignInScreen.routeName: (ctx) => SignInScreen(),
        UserData.routeName: (ctx) => UserData(),
      },
    );
  }
}
