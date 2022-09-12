import 'package:cite_finder_admin/app/components/CircularButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  MapWidget(
      {Key? key,
      required this.initialCameraPosition,
      this.markers = const <Marker>{},
      this.onTap,
      this.onLongPress,
      this.showBackButton = false,
      this.onHomeTap,
      this.showHomeButton = false,
      this.onMapCreated})
      : super(key: key);

  // final GoogleMapController mapController;
  final Function(GoogleMapController)? onMapCreated;
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final void Function(LatLng)? onTap;
  final void Function(LatLng)? onLongPress;
  final VoidCallback? onHomeTap;
  final bool showBackButton;
  final bool showHomeButton;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        children: [
          GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              onTap: onTap,
              myLocationEnabled: true,
              onLongPress: onLongPress),
          if (showBackButton)
            Positioned(
                top: 10,
                left: 15,
                child: CircularButton(
                    child: Icon(Icons.navigate_before),
                    color: Colors.white,
                    onTap: () {
                      Get.back();
                    })),
          if (showHomeButton)
            Positioned(
                top: 70,
                left: 15,
                child: CircularButton(
                    child: Icon(Icons.home),
                    color: Colors.white,
                    onTap: onHomeTap))
        ],
      ),
    );
  }
}
