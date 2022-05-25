// ignore_for_file: avoid_print

import 'package:geolocator/geolocator.dart';

class CustomLocationPicker {
  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } 
    print(await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ));
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
