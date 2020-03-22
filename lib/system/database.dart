import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_your_visits/models/store.dart';
import 'package:track_your_visits/models/user.dart';

class DatabaseService {
  final CollectionReference users = Firestore.instance.collection('users'),
      stores = Firestore.instance.collection('stores');

  Firestore txn = Firestore.instance;

  Future registerNewUser() async {
    await users.document(User.id).setData(User.generateUserMap());
  }

  Future registerStore(Store store) async {
    await stores.document(store.id).setData(store.generateMap());
  }

  Stream<List<Store>> streamLastStores() {
    return users
        .document(User.id)
        .collection('history')
        .snapshots()
        .asyncMap(_convertInStoreList);
  }

  Future<List<Store>> _convertInStoreList(QuerySnapshot snap) async {
    List<Store> storeList = [];
    for (var doc in snap.documents) {
      var storeId = doc.data['store'];
      var store = await getStore(storeId);
      Timestamp time = doc.data['zeit'];
      store.setTime(time.toDate().add(Duration(hours: 5)));
      store.setVisitId(doc.documentID);
      storeList.add(store);
    }
    storeList.sort((s1, s2) =>
        s2.zeit.millisecondsSinceEpoch - s1.zeit.millisecondsSinceEpoch);
    return storeList;
  }

  Future visitStore(String storeId) async {
    var ref = await stores
        .document(storeId)
        .collection('visits')
        .add({'user': User.id, 'zeit': FieldValue.serverTimestamp()});
    await users.document(User.id).collection('history').add({
      'store': storeId,
      'zeit': FieldValue.serverTimestamp(),
      'ref': ref.path
    });
  }

  Future<Store> getStore(String storeId) async {
    print('read');
    var doc = await stores.document(storeId).get();
    return _convertInStore(doc);
  }

  Future deleteVisit(String visitId) async {
    var doc = await users
        .document(User.id)
        .collection('history')
        .document(visitId)
        .get();
    var ref = Firestore.instance.document(doc.data['ref']);
    await ref.delete();
    await users
        .document(User.id)
        .collection('history')
        .document(visitId)
        .delete();
  }

  Store _convertInStore(DocumentSnapshot snap) {
    print('read');
    if (!snap.exists) return Store.empty;
    return Store(
        adresse: snap.data['adresse'],
        id: snap.documentID,
        name: snap.data['name']);
  }

  Future fetchUser() async {
    var doc = await users.document(User.id).get();
    print('read');
    print(doc.exists);
    User.adresse = doc.data['adresse'] ?? null;
    User.email = doc.data['email'] ?? null;
    User.nachname = doc.data['nachname'] ?? null;
    User.vorname = doc.data['vorname'] ?? null;
    User.telefon = doc.data['telefon'] ?? null;
    User.storeId = doc.data['storeId'] ?? null;
  }
}
