const GOOGLE_API_KEY = 'AIzaSyDOZ-IJ02Wve29fPGSC2EM_XZ5qdyNm42A';

class LocationUtil {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return '''https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=satellite&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY''';
  }
}
