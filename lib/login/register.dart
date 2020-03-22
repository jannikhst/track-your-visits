import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:track_your_visits/system/authenticator.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Authenticator _auth = Authenticator();
  Widget _buttonSwitcher;
  Widget _button;
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  Widget _loading() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.teal[300]),
      child: Container(
        height: 20,
        width: 150,
        child: LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  @override
  initState() {
    _button = GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            _buttonSwitcher = _loading();
          });
          var result =
              await _auth.registerWithEmailAndPassword(email, password);
          if (result.containsKey('error')) {
            setState(() {
              _buttonSwitcher = _button;
              Flushbar(
                title: result['error'].toString(),
                message: result['message'].toString(),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.redAccent,
                flushbarPosition: FlushbarPosition.TOP,
              )..show(context);
            });
          } else {
            Navigator.pop(context);
          }
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.teal[300]),
          child: Text(
            'Account erstellen',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          )),
    );
    _buttonSwitcher = _button;
    super.initState();
  }

  List<FocusNode> focusAuto = List<FocusNode>.generate(3, (index) {
    return new FocusNode();
  });

  final inputDec = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.teal,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewInsets.bottom,
                  decoration: BoxDecoration(color: Colors.teal[400]),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.white,
                      hintColor: Colors.white,
                      cursorColor: Colors.white,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            focusNode: focusAuto[0],
                            decoration: InputDecoration(
                                enabledBorder: inputDec,
                                errorStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold),
                                border: inputDec,
                                hintText: 'Deine Email-Adresse'),
                            validator: (val) => val.isEmpty
                                ? 'Gib eine gültige Email an'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(focusAuto[1]);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            focusNode: focusAuto[1],
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
                                hintText: 'Wähle ein Passwort'),
                            validator: (val) => val.length < 6
                                ? 'Dein Passwort besteht aus 6+ Zeichen'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            onFieldSubmitted: (value) async {
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(focusAuto[2]);
                                var result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password);
                                if (result.containsKey('error')) {
                                  setState(() {
                                    Flushbar(
                                      title: result['error'].toString(),
                                      message: result['message'].toString(),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.redAccent,
                                      flushbarPosition: FlushbarPosition.TOP,
                                    )..show(context);
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 400),
                            child: _buttonSwitcher,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Icon(
                    Icons.clear,
                    color: Colors.teal,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
