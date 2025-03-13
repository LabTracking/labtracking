import 'package:flutter_dotenv/flutter_dotenv.dart';

final GOOGLE_API_KEY = dotenv.env['GOOGLE_MAPS_API_KEY'];

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return '''https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=satellite&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY''';
  }
}
