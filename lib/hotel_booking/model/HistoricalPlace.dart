import 'package:cloud_firestore/cloud_firestore.dart';

class HistoricalPlace {
  final String title;
  final GeoPoint coordinates;
  final String imagePath;

  HistoricalPlace({
    required this.title,
    required this.coordinates,
    required this.imagePath,
  });

  factory HistoricalPlace.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return HistoricalPlace(
      title: data['title'] ?? '',
      coordinates: data['coordinates'] ?? GeoPoint(0, 0),
      imagePath: data['imagePath'] ?? '',
    );
  }
}
