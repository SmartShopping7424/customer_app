import 'dart:math';
import 'package:customer_app/utils/toaster.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

const double earthRadius = 6371;

class Getlocation {
  // get location permission
  static Future<bool> getLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // if location service is disabled
    if (!serviceEnabled) {
      Toaster.toastMessage(
          "Location services are disabled. Please enable the services.",
          context);
      return false;
    }

    // check the permission
    permission = await Geolocator.checkPermission();

    // if permission is denied
    if (permission == LocationPermission.denied) {
      // request for permission
      permission = await Geolocator.requestPermission();

      // if permission again denied
      if (permission == LocationPermission.denied) {
        Toaster.toastMessage("Location permissions are denied.", context);
        return false;
      }
    }

    // if permission is denied forever
    if (permission == LocationPermission.deniedForever) {
      Toaster.toastMessage(
          "Location permissions are permanently denied. Please allow form the your settings.",
          context);
      return false;
    }

    // if have permission
    return true;
  }

  // get current position
  static getCurrentPosition(context) async {
    // check for the permission
    final hasPermission = await getLocationPermission(context);

    // if there is no permission
    if (!hasPermission) {
      return false;
    }

    // if there is permission
    else {
      try {
        var res = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        return res;
      } catch (e) {
        return false;
      }
    }
  }

  // get address from latitude and longitude
  static getAddressFromLatLng(position) async {
    try {
      var data = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
      var place = data[0];
      var address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
      return address;
    } catch (e) {
      return false;
    }
  }

  // convert to radian
  static toRadians(double degree) {
    return degree * pi / 180;
  }

  // calculate distance in m between 2 latitude and longitude
  static getDistanceBtwLatLng(
      double lat1, double lon1, double lat2, double lon2) async {
    var dLat = toRadians(lat2 - lat1);
    var dLon = toRadians(lon2 - lon1);
    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var km = earthRadius * c;
    return km * 1000;
  }
}
