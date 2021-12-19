import 'package:geolocator/geolocator.dart';
import '/domain/services/location_interface.dart';

class GpsService implements LocationInterface {
  @override
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
