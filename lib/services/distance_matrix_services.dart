import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CalculateDistanceService {
  static const String apiKey = 'AIzaSyCddg-WOq5Jtr9KZ4OnVf2htQBp5e-ursk';

  Future<Map<String, dynamic>> getCoordinates(String zipCode) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$zipCode&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].length > 0) {
        final lat = data['results'][0]['geometry']['location']['lat'];
        final lng = data['results'][0]['geometry']['location']['lng'];
        return {'lat': lat, 'lng': lng};
      } else {
        throw Exception('Zip code not found');
      }
    } else {
      throw Exception('Failed to load coordinates');
    }
  }

  Future<String?> getDistance(
      String originZipCode, String destinationZipCode) async {
    try {
      final originCoordinates = await getCoordinates(originZipCode);
      final destinationCoordinates = await getCoordinates(destinationZipCode);

      final response = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${originCoordinates['lat']},${originCoordinates['lng']}&destinations=${destinationCoordinates['lat']},${destinationCoordinates['lng']}&key=$apiKey'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final distanceInMiles =
            data['rows'][0]['elements'][0]['distance']['text'];
        return distanceInMiles;
      } else {
        throw Exception('Failed to load distance');
      }
    } catch (error) {
      print('Error: ${error.toString()}');
      return null;
    }
  }
}
