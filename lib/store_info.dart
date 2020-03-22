import 'package:flutter/material.dart';
import 'package:track_your_visits/models/store.dart';

class StoreInfo extends StatelessWidget {
  final Store store;
  final bool visited;
  StoreInfo(this.store, this.visited);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (visited)
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 35,
                ),
              if (visited)
                Text(
                  'Besuch eingetragen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold),
                ),
              if (!visited)
                Text(
                  'Store wurde nicht gefunden!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.redAccent, fontSize: 25),
                ),
              SizedBox(height: 20),
              Text(store.name),
              Text(store.adresse),
            ],
          ),
        ),
        SizedBox(height: 20),
        LayoutBuilder(builder: (_, constraints) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              width: constraints.maxWidth,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(25)),
                  color: Colors.teal),
              child: Text(
                'Fertig',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Quicksand',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        })
      ],
    );
  }
}
