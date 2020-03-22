class Store {
  String id;
  String name;
  String adresse;
  DateTime zeit;
  String visitId;

  Map<String, dynamic> generateMap() {
    return {'name': name, 'adresse': adresse};
  }

  void setTime(DateTime date) {
    zeit = date;
  }

  void setVisitId(String id) {
    visitId = id;
  }

  Store({this.adresse, this.id, this.name});

  static get empty {
    return Store(
        adresse: 'Keine Adresse',
        id: 'empty',
        name: 'Store konnte nicht gefunden werden');
  }
}
