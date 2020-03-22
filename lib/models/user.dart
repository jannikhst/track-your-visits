class User {
  static String id;
  static String vorname;
  static String nachname;
  static String telefon;
  static String email;
  static String adresse;
  static String storeId;

  static Map<String, dynamic> generateUserMap() {
    return {
      'id': id,
      'vorname': vorname,
      'nachname': nachname,
      'telefon': telefon,
      'email': email,
      'adresse': adresse,
      'storeId': storeId,
    };
  }
}
