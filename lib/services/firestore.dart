import 'package:cloud_firestore/cloud_firestore.dart';

import '../hotel_booking/model/HistoricalPlace.dart';

class FireStoreService {
  final CollectionReference historicalPlaces = FirebaseFirestore.instance.collection('historical_places');

  Future<void> addNote(String title, GeoPoint coordinates, String imagePath) {
    return historicalPlaces.add({
      'title': title,
      'coordinates': coordinates,
      'imagePath': imagePath,
    });
  }

  Stream<List<HistoricalPlace>> getHistoricalPlaces() {
    return historicalPlaces.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => HistoricalPlace.fromFirestore(doc)).toList();
    });
  }
}
