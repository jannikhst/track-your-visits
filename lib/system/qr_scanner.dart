// import 'dart:io';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscan/qrscan.dart' as androidScanner;
import 'package:flutter/services.dart';

class QrCodeScanner {
  QrCodeScanner();

  String _barcode = '-';

  // Future scan() async {
  //   if (Platform.isIOS) {
  // try {
  //   String barcode = await BarcodeScanner.scan();
  //   this._barcode = barcode;
  // } on PlatformException catch (e) {
  //   if (e.code == BarcodeScanner.CameraAccessDenied) {
  //     this._barcode = 'The user did not grant the camera permission!';
  //   } else {
  //     this._barcode = 'Unknown error: $e';
  //   }
  // } on FormatException {
  //   this._barcode =
  //       'null (User returned using the "back"-button before scanning anything. Result)';
  // } catch (e) {
  //   this._barcode = 'Unknown error: $e';
  // }
  //   } else {}
  //   try {
  //     String _barcode = await androidScanner.scan();
  //     this._barcode = _barcode;
  //   } on PlatformException catch (e) {
  //     if (e.code == androidScanner.CameraAccessDenied) {
  //       this._barcode = 'The user did not grant the camera permission!';
  //     } else {
  //       this._barcode = 'Unknown error: $e';
  //     }
  //   } on FormatException {
  //     this._barcode =
  //         'null (User returned using the "back"-button before scanning anything. Result)';
  //   } catch (e) {
  //     this._barcode = 'Unknown error: $e';
  //   }
  // }

  Future scan() async {
    try {
      _barcode = await androidScanner.scan();
      print(_barcode);
    } on PlatformException catch (e) {
      if (e.code == androidScanner.CameraAccessDenied) {
        this._barcode = 'The user did not grant the camera permission!';
      } else {
        this._barcode = 'Unknown error: $e';
      }
    } on FormatException {
      this._barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      this._barcode = 'Unknown error: $e';
    }
  }

  String get getCode {
    print(_barcode);
    return _barcode;
  }
}
