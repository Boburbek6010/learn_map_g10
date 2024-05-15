import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomYandexMap extends StatefulWidget {
  const CustomYandexMap({super.key});

  @override
  State<CustomYandexMap> createState() => _CustomYandexMapState();
}

class _CustomYandexMapState extends State<CustomYandexMap> {
  late YandexMapController yandexMapController;
  late Position myPosition;
  bool isLoading = false;

  void onMapCreated(YandexMapController controller) {
    yandexMapController = controller;
    yandexMapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
          zoom: 13,
          tilt: 900,
          azimuth: 180,
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    myPosition = await Geolocator.getCurrentPosition();
    isLoading = true;
    setState(() {});
    return myPosition;
  }

  void findMe() {
    yandexMapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
            zoom: 18,
            tilt: 50,
            azimuth: 180,
          ),
        ),
        animation: const MapAnimation(type: MapAnimationType.smooth, duration: 2));

    yandexMapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
            zoom: 19,
            tilt: 90,
            azimuth: 180,
          ),
        ),
        animation: const MapAnimation(type: MapAnimationType.smooth, duration: 4));

    // var boundingBox = BoundingBox(
    //   northEast: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
    //   southWest: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
    // );
    //
    // yandexMapController.moveCamera(
    //   CameraUpdate.newTiltAzimuthGeometry(
    //     Geometry.fromBoundingBox(boundingBox),
    //   ),
    // );
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? YandexMap(
              onMapCreated: onMapCreated,
              onMapTap: (Point point){
                debugPrint(point.latitude.toString());
                debugPrint(point.longitude.toString());
              },
              mode2DEnabled: false,
              nightModeEnabled: true,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          findMe();
        },
        child: const Icon(Icons.gps_fixed_rounded),
      ),
    );
  }
}
