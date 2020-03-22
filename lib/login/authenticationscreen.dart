import 'package:flutter/material.dart';
import 'package:track_your_visits/login/register.dart';
import 'package:track_your_visits/login/set_user_data.dart';
import 'package:track_your_visits/login/signin.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add_alert, color: Colors.teal, size: 75),
            SizedBox(height: 40),
            RaisedButton(
              color: Colors.teal,
              onPressed: () {
                Navigator.pushNamed(context, UserData.routeName);
              },
              child: Text(
                'Registrieren',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.teal,
              onPressed: () {
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
              child: Text(
                ' Anmelden ',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
