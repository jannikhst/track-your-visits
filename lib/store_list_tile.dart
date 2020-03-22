import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_your_visits/models/store.dart';
import 'package:track_your_visits/system/database.dart';

class StoreListTile extends StatelessWidget {
  final Store store;
  StoreListTile(this.store);

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
            'Eintrag löschen?',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.teal,
          // boxShadow: [
          //   BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 2)
          // ],
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            DateFormat("d.MM.y HH:mm").format(store.zeit),
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    store.name,
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    store.adresse,
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Quicksand'),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              _createDialog(
                  context,
                  _alert(context, () async {
                    Navigator.pop(context);
                    await DatabaseService().deleteVisit(store.visitId);
                  }, Icons.delete));
            },
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
