import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  Rx<Position?> currentDevicePosition = Rx(null);

  static LocationController get to => Get.find();

  Future<Position?> determineCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      final isSettingsOpened = await Geolocator.openLocationSettings();

      if (!isSettingsOpened) {
        Get.snackbar("Error", "Unable to get your location");

        return null;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Get.snackbar("Error", "Unable to get your location");

        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Get.snackbar("Error",
          'Location permissions are permanently denied, we cannot request permissions.');

      final isSettingsOpened = await Geolocator.openLocationSettings();

      if (!isSettingsOpened) {
        Get.snackbar("Error", "Unable to get your location");

        return null;
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    try {
      final pos = await Geolocator.getCurrentPosition();
      currentDevicePosition.value = pos;
      refresh();
      return pos;
    } on TimeoutException catch (err) {
      print(err);
      Get.snackbar("Error", "Timeout");
    } on LocationServiceDisabledException catch (err) {
      print(err);
      Get.snackbar("Info", "Please enable the location service of your device");
    } on Exception catch (err) {
      print(err);
    }

    return null;
  }
}
