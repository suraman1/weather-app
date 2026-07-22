import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  static final _apiKey = dotenv.env['OPENWEATHER_API'];

  Map<String, dynamic> _weatherData = {};
  List<dynamic> _forcastData = [];
  String _currentCity = "Addis Ababa";

  String get currentCity => _currentCity;
  Map<String, dynamic> get weatherData => _weatherData;
  List<dynamic> get forcastData => _forcastData;

  set setCurrentCity(String city) {
    _currentCity = city;
  }

  Future<void> fetchWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$_currentCity&appid=$_apiKey&units=metric",
        ),
      );
      if (res.statusCode == 200) {
        _weatherData = json.decode(res.body);
      }
      await _fetchForcast();
      notifyListeners();

    } catch (e) {
      throw Exception("Unexpected error occured!");
    }
  }

  Future<void> _fetchForcast() async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forcast?q=$_currentCity&appid=$_apiKey&units=metric",
        ),
      );
      if (res.statusCode == 200) {
        _forcastData = json.decode(res.body)['list'];
      }
    } catch (e) {
      throw Exception("Unexpected error occured!");
    }
  }
}
