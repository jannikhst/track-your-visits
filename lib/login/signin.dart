import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:track_your_visits/system/authenticator.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Authenticator _auth = Authenticator();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  Widget _buttonSwitcher;
  Widget _button;
  List<FocusNode> focusAuto = List<FocusNode>.generate(3, (index) {
    return new FocusNode();
  });

  Widget _loading() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.blue[400]),
      child: Container(
        height: 20,
        width: 100,
        child: LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  @override
  void initState() {
    _button = GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            _buttonSwitcher = _loading();
          });
          print(email);
          print(password);
          var result = await _auth.signInWithEmailAndPassword(email, password);
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
          } else if (result.containsKey('verify')) {
            Flushbar(
              title: result['verify'].toString(),
              message: result['message'].toString(),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.blueGrey,
              flushbarPosition: FlushbarPosition.TOP,
            )..show(context);
          } else {
            Navigator.pop(context);
          }
          setState(() {
            _buttonSwitcher = _button;
          });
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue[400]),
          child: Text(
            'Anmelden',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          )),
    );
    _buttonSwitcher = _button;
    super.initState();
  }

  final inputDec = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: Colors.white));
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewInsets.bottom,
                  decoration: BoxDecoration(color: Colors.blue),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.white,
                      hintColor: Colors.white,
                      cursorColor: Colors.white,
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: focusAuto[0],
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                enabledBorder: inputDec,
                                border: inputDec,
                                errorStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold),
                                hintText: 'Deine Email'),
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
                            decoration: InputDecoration(
                                enabledBorder: inputDec,
                                errorStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold),
                                border: inputDec,
                                hintText: 'Dein Passwort'),
                            validator: (val) => val.length < 6
                                ? 'Passwort muss 6+ Zeichen lang sein'
                                : null,
                            obscureText: true,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Quicksand',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            onChanged: (val) {
                              password = val;
                            },
                            onFieldSubmitted: (value) async {
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context)
                                    .requestFocus(focusAuto[2]);
                                var result =
                                    await _auth.signInWithEmailAndPassword(
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
                                } else if (result.containsKey('verify')) {
                                  Flushbar(
                                    title: result['verify'].toString(),
                                    message: result['message'].toString(),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.blueGrey,
                                    flushbarPosition: FlushbarPosition.TOP,
                                  )..show(context);
                                } else {
                                  Navigator.pop(context);
                                }
                              }
                            },
                          ),
                          SizedBox(height: 20.0),
                          AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: _buttonSwitcher),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () async {
                              String message;
                              String title;
                              Color color = Colors.redAccent;
                              if (email.isEmpty) {
                                title = 'Keine Emailadresse angegeben!';
                                message = 'Gib eine gültige Email an.';
                              } else {
                                var result =
                                    await _auth.requestPasswordReset(email);
                                if (!result.containsKey('error')) {
                                  color = Colors.green;
                                  title = 'Email versendet';
                                  message = 'Überprüfe dein Postfach';
                                } else {
                                  title = result['error'];
                                  message = result['message'];
                                }
                              }
                              Flushbar(
                                title: title,
                                message: message,
                                duration: Duration(seconds: 3),
                                backgroundColor: color,
                                flushbarPosition: FlushbarPosition.TOP,
                              )..show(context);
                            },
                            child: Text(
                              'Passwort vergessen',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
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
                    color: Colors.blue,
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
