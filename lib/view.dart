import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_your_visits/models/store.dart';
import 'package:track_your_visits/models/user.dart';
import 'package:track_your_visits/store_info.dart';
import 'package:track_your_visits/store_list_tile.dart';
import 'package:track_your_visits/system/authenticator.dart';
import 'package:track_your_visits/system/database.dart';
import 'package:track_your_visits/system/qr_scanner.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final QrCodeScanner scanner = QrCodeScanner();

  _createDialog(BuildContext ctx, Widget widget) {
    return showDialog(
        context: ctx,
        builder: (ctx) {
          return Dialog(
            backgroundColor: Colors.white,
            child: widget,
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          );
        });
  }

  Widget _alert(BuildContext ctx, Function function, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Willst du dich abmelden?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blueGrey,
                fontFamily: 'Quicksand',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    child: Icon(Icons.clear, color: Colors.green, size: 50),
                  ),
                ),
                SizedBox(width: 70),
                GestureDetector(
                  onTap: function,
                  child: Container(
                    child: Icon(icon, color: Colors.redAccent, size: 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future syncUser() async {
    DatabaseService().fetchUser().then((_) {
      setState(() {});
    });
  }

  @override
  void initState() {
    syncUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stores = Provider.of<List<Store>>(context) ?? [];
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              _createDialog(
                  context,
                  _alert(context, () {
                    Navigator.pop(context);
                    Authenticator().signOut();
                  }, Icons.exit_to_app));
            },
            label: Text(
              'Abmelden',
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          )
        ],
        title: Text('Hallo ${User.vorname}!'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      await scanner.scan();
                      var store =
                          await DatabaseService().getStore(scanner.getCode);
                      if (store.id != 'empty') {
                        await DatabaseService().visitStore(store.id);
                        _createDialog(context, StoreInfo(store, true));
                      } else {
                        _createDialog(context, StoreInfo(store, false));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.teal,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 30,
                                spreadRadius: 10)
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.shopping_cart,
                              size: 50, color: Colors.white),
                          Text(
                            'Eintrag erstellen',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                children: <Widget>[
                  Text(
                    'Meine Einträge',
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold),
                  ),
                  if (stores.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                          itemCount: stores.length,
                          itemBuilder: (_, index) {
                            return StoreListTile(stores[index]);
                          }),
                    ),
                  if (stores.isEmpty)
                    Text(
                      'Noch keine Einträge vorhanden',
                      style: TextStyle(
                          color: Colors.teal,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
