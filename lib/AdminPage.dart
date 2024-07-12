import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:mc_history_gemini/hotel_booking/hotel_app_theme.dart';
import 'services/firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final FireStoreService _fireStoreService = FireStoreService();

  void _addHistoricalPlace() {
    final String title = _titleController.text;
    final double latitude = double.tryParse(_latitudeController.text) ?? 0.0;
    final double longitude = double.tryParse(_longitudeController.text) ?? 0.0;
    final String imagePath = _imagePathController.text;
    final GeoPoint coordinates = GeoPoint(latitude, longitude);

    if (title.isNotEmpty && imagePath.isNotEmpty) {
      _fireStoreService.addNote(title, coordinates, imagePath).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Historical place added successfully')),
        );
        _titleController.clear();
        _latitudeController.clear();
        _longitudeController.clear();
        _imagePathController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add historical place: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Historical Places Repo",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FlutterLocationPicker(
                  initPosition: LatLong(23, 89),
                  selectLocationButtonStyle: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(HotelAppTheme.buildLightTheme().primaryColor),
                  ),
                  selectLocationButtonText: 'Set Current Location',
                  initZoom: 11,
                  minZoomLevel: 5,
                  maxZoomLevel: 19,
                  trackMyPosition: true,
                  onError: (e) => print(e),
                  onPicked: (pickedData) {
                    setState(() {
                      _latitudeController.text = pickedData.latLong.latitude.toString();
                      _longitudeController.text = pickedData.latLong.longitude.toString();
                    });
                    print(pickedData.latLong.latitude);
                    print(pickedData.latLong.longitude);
                    print(pickedData.address);
                    print(pickedData.addressData['country']);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Positioned(
            bottom: 70, // Adjust the value as needed
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _latitudeController,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _longitudeController,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _imagePathController,
                            decoration: InputDecoration(
                              labelText: 'Image Path',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _addHistoricalPlace();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: HotelAppTheme.buildLightTheme().primaryColor, // Change the background color
                              onPrimary: Colors.white, // Change the text color
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
                              ),
                            ),
                            child: Text(
                              'Add Historical Place',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
          SizedBox(height: 7),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }
}
