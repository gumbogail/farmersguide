import 'dart:convert';
import 'package:farmersguide/stormresult.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitySelectionStorm extends StatefulWidget {
  const CitySelectionStorm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CitySelectionStormState createState() => _CitySelectionStormState();
}

class _CitySelectionStormState extends State<CitySelectionStorm> {
  final TextEditingController _cityController = TextEditingController();
  late double latitude;
  late double longitude;

  // Function to fetch coordinates based on city name
  Future<void> _getCoordinatesFromCity(String cityName) async {
    String apiKey =
        "2381429f64d640a29be0e24e30de2372"; // Replace with your API key
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$cityName&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var results = data['results'][0]['geometry'];
        latitude = results['lat'];
        longitude = results['lng'];

        // Send the real latitude and longitude to the storm model (FastAPI)
        _sendCoordinatesToStormModel(latitude, longitude);

        // Navigate to the StormPredictionPage after fetching coordinates
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PredictionStorm(latitude: latitude, longitude: longitude),
          ),
        );
      } else {
        if (kDebugMode) {
          print("Error fetching coordinates: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching coordinates: $e");
      }
    }
  }

  // Function to send the coordinates to FastAPI for storm predictions
  Future<void> _sendCoordinatesToStormModel(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://storm-models.onrender.com/predict_storm?latitude=$latitude&longitude=$longitude');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Storm prediction received");
        }
      } else {
        if (kDebugMode) {
          print("Error: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending coordinates to storm model: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select City for Storm Prediction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String city = _cityController.text;
                if (city.isNotEmpty) {
                  _getCoordinatesFromCity(city);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

class StormPredictionPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  const StormPredictionPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storm Predictions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude'),
            // Display the storm prediction results here after calling the API
            // You can extend this to display the actual prediction results in the future
          ],
        ),
      ),
    );
  }
}