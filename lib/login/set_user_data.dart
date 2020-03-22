import 'package:flutter/material.dart';
import 'package:track_your_visits/login/register.dart';
import 'package:track_your_visits/models/user.dart';

class UserData extends StatelessWidget {
  static const routeName = '/setuserdata';
  String vorname;
  String nachname;
  final inputDec = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.lightBlue,
        child: SafeArea(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.lightBlue,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Quicksand',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          enabledBorder: inputDec,
                          errorStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                          border: inputDec,
                          hintText: 'Deine Vorname'),
                      onChanged: (val) {
                        vorname = val;
                      },
                      onFieldSubmitted: (val) {
                        vorname = val;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Quicksand',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          enabledBorder: inputDec,
                          errorStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold),
                          border: inputDec,
                          hintText: 'Dein Nachname'),
                      onChanged: (val) {
                        nachname = val;
                      },
                      onFieldSubmitted: (val) {
                        nachname = val;
                      },
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        User.vorname = vorname;
                        User.nachname = nachname;
                        Navigator.popAndPushNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.lightBlue[400]),
                          child: Text(
                            'Weiter',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                User.vorname = vorname;
                User.nachname = nachname;
                Navigator.popAndPushNamed(context, RegisterScreen.routeName);
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.teal,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
