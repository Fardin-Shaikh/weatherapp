import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/current_weather.dart';
import 'package:weatherapp/models/forcast.dart';

class Fetch {
  static final Fetch insta = Fetch._init();
  Fetch._init();
  final String apiKey1 =
      '085b4ec3049cb4c6d33fa15c173974a3'; //API TO FEATCH CURRENT WEATHER
  final String apiKey2 =
      '4baed348666d4d40b4a70946241802'; //API TO FEATCH FORCAST  WEATHER
  final String days = '9';

  Future<CurrentWeather?> weatherNow(Position position) async {
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      return CurrentWeather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<ForcastWeather?> weatherForcast(Position position) async {
    final String location = '${position.latitude},${position.longitude}';
    final String url =
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey2&q=$location&days=$days';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log(response.body);
      final Map<String, dynamic> jsonData = json.decode(response.body);

      return ForcastWeather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
