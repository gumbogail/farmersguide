import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherData extends StatefulWidget {
  final String region;

  const WeatherData({super.key, required this.region});

  @override
  _WeatherDataState createState() => _WeatherDataState();
}

class _WeatherDataState extends State<WeatherData> {
  Map<String, dynamic>? _currentWeather;
  List<dynamic>? _predictions;
  final String _apiKey =
      '3a0d4c4e3e304fdd92e190019243007'; // Replace with your weather API key

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() async {
    final weatherResponse = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/current.json?key=$_apiKey&q=${widget.region}'));
    final weatherData = json.decode(weatherResponse.body);

    final predictionsResponse = await http.get(Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=${widget.region}&days=90'));
    final predictionsData = json.decode(predictionsResponse.body);

    setState(() {
      _currentWeather = weatherData['current'];
      _predictions = predictionsData['forecast']['forecastday'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.region} Weather Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentWeather == null || _predictions == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _buildCurrentWeather(),
                  _buildPredictions(),
                ],
              ),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Current Weather',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ListTile(
          title: Text('Temperature: ${_currentWeather!['temp_c']}°C'),
          subtitle: Text('Condition: ${_currentWeather!['condition']['text']}'),
        ),
        ListTile(
          title: Text('Humidity: ${_currentWeather!['humidity']}%'),
        ),
        ListTile(
          title: Text('Wind Speed: ${_currentWeather!['wind_kph']} kph'),
        ),
      ],
    );
  }

  Widget _buildPredictions() {
    //this will need to change
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('3-Month Predictions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ..._predictions!.map((prediction) {
          return ListTile(
            title: Text(prediction['date']),
            subtitle: Text(
                'Max Temp: ${prediction['day']['maxtemp_c']}°C, Min Temp: ${prediction['day']['mintemp_c']}°C'),
          );
        }).toList(),
      ],
    );
  }
}
