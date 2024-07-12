import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firestore.dart';
import 'hotel_booking/model/HistoricalPlace.dart';

class HistoricalPlacesPage extends StatelessWidget {
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historical Places"),
      ),
      body: StreamBuilder<List<HistoricalPlace>>(
        stream: _fireStoreService.getHistoricalPlaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final historicalPlaces = snapshot.data!;
          return ListView.builder(
            itemCount: historicalPlaces.length,
            itemBuilder: (context, index) {
              final place = historicalPlaces[index];
              return ListTile(
                leading: Image.network(place.imagePath), // Make sure imagePath is a valid URL
                title: Text(place.title),
                subtitle: Text('Coordinates: ${place.coordinates.latitude}, ${place.coordinates.longitude}'),
              );
            },
          );
        },
      ),
    );
  }
}
