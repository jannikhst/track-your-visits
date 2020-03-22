import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:track_your_visits/models/user.dart';
import 'package:track_your_visits/system/database.dart';


class Authenticator {
  // static Timer streamTimer;
  // static bool shouldStream = false;
  // static StreamController<bool> _controller =
  //     StreamController<bool>.broadcast();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // _startStream() {
  //   streamTimer = Timer.periodic(Duration(seconds: 2), (t) async {
  //     if (shouldStream) {
  //       if (!_controller.hasListener) {
  //         closeStream();
  //         return;
  //       }
  //       var x = await _auth.currentUser();
  //       if (x == null) {
  //         closeStream();
  //         return;
  //       }
  //       await x.reload();
  //       print(x.isEmailVerified);
  //       _controller.sink.add(x.isEmailVerified);
  //     } else {
  //       closeStream();
  //     }
  //   });
  // }

  // static closeStream() {
  //   shouldStream = false;
  //   streamTimer.cancel();
  //   _controller.close();
  // }

  // Future checkStatus() async {
  //   var x = await _auth.currentUser();
  //   await x.reload();
  //   if (!x.isEmailVerified) {
  //     await DatabaseService().deleteUser();
  //     await signOut();
  //   }
  // }

  // Stream<bool> get verifiedStream {
  //   if (streamTimer == null || !streamTimer.isActive || _controller.isClosed) {
  //     shouldStream = true;
  //     _controller = StreamController<bool>.broadcast();
  //     _startStream();
  //     print('##newStream##');
  //   }
  //   return _controller.stream;
  // }

  // Future<User> _getUser(FirebaseUser user) async {
  //   if (user != null) {
  //     return await DatabaseService().fetchUserUpdate();
  //   } else {
  //     return null;
  //   }
  // }

  // Future setEmail() async {
  //   var x = await _auth.currentUser();
  //   User.email = x.email;
  // }

  Stream<FirebaseUser> get userStream {
    return _auth.onAuthStateChanged;
  }

  Future deleteUser() async {
    var x = await _auth.currentUser();
    await x.reload();
    await x.delete();
    await signOut();
  }

  // Future<User> get user async {
  //   return _getUser(await _auth.currentUser());
  // }

  //register with email & password
  Future<Map<String, dynamic>> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      User.id = user.uid;
      User.email = email;

      print('Data->User');
      await DatabaseService().registerNewUser();
      print('User->Database');
      return {};
      // return _getUser(user);
    } catch (e) {
      if (e.toString().contains('ERROR_INVALID_EMAIL')) {
        return {
          'error': 'Ungültige Email',
          'message': 'Überprüfe deine Email auf richtige Zeichensetzung.'
        };
      }
      if (e.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        return {
          'error': 'Nutzer existiert bereits!',
          'message': 'Du kannst dich nicht erneut registrieren.'
        };
      }
      print(e.toString());
      return {
        'error': 'Ein Fehler ist aufgetreten!',
        'message': 'Überprüfe deine Netzwerkverbindung und versuche es erneut.'
      };
    }
  }

  Future<Map<String, dynamic>> sendVerificationRequest() async {
    var user = await _auth.currentUser();
    await user.sendEmailVerification();
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {};
    } catch (e) {
      if (e.toString().contains('ERROR_INVALID_EMAIL')) {
        return {
          'error': 'Ungültige Email',
          'message': 'Überprüfe deine Email auf richtige Zeichensetzung.'
        };
      }
      if (e.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
        return {
          'error': 'Zu viele Anfragen!',
          'message': 'Versuche es später erneut.'
        };
      }
      if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
        return {
          'error': 'Nutzer existiert nicht!',
          'message': 'Überprüfe deine Email und versuche es erneut.'
        };
      }
      return {
        'error': 'Ein Fehler ist aufgetreten!',
        'message': 'Überprüfe deine Netzwerkverbindung und versuche es erneut.'
      };
    }
  }

  //sign in with email & password
  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      User.id = user.uid;
      // if (!user.isEmailVerified) {
      //   await user.sendEmailVerification();
      //   print('SEND');
      //   signOut();
      //   return {
      //     'verify': 'Deine Email wurde noch nicht verifiziert!',
      //     'message': 'Wir haben Dir erneut eine Email gesendet.'
      //   };
      // }
      return {};
    } catch (e) {
      print(e.toString());
      if (email == null || password == null) {
        return {
          'error': 'Ungültige Eingabe',
          'message': 'Überprüfe deine Angaben'
        };
      }
      if (e.toString().contains('ERROR_INVALID_EMAIL')) {
        return {
          'error': 'Ungültige Email',
          'message': 'Überprüfe deine Email auf richtige Zeichensetzung.'
        };
      }
      if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
        return {
          'error': 'Nutzer existiert nicht!',
          'message': 'Überprüfe deine Email und versuche es erneut.'
        };
      }
      if (e.toString().contains('ERROR_WRONG_PASSWORD')) {
        return {
          'error': 'Falsches Passwort für diesen Account!',
          'message': 'Du kannst dein Passwort zurücksetzen lassen.'
        };
      }
      if (e.toString().contains('ERROR_TOO_MANY_REQUESTS')) {
        return {
          'error': 'Zu viele Anfragen!',
          'message': 'Versuche es später erneut.'
        };
      }
      return {
        'error': 'Ein Fehler ist aufgetreten!',
        'message': 'Überprüfe deine Netzwerkverbindung und versuche es erneut.'
      };
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
