import 'package:flutter/material.dart';
import 'package:mc_history_gemini/hotel_booking/hotel_app_theme.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
class Map extends StatefulWidget {
  final double? longitude;
  final double? latitude;
  const Map({Key? key, required this.longitude,required this.latitude}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterLocationPicker(
              initPosition: LatLong(23, 89),
              selectLocationButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(HotelAppTheme.buildLightTheme().primaryColor),
              ),
              selectLocationButtonText: 'Set Current Location',
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 19,
              trackMyPosition: true,
              onError: (e) => print(e),
              onPicked: (pickedData) {
                print(pickedData.latLong.latitude);
                print(pickedData.latLong.longitude);
                print(pickedData);
                print(pickedData.address);
                print(pickedData.addressData['country']);
              })
        ],
      ),
    );
  }
}
