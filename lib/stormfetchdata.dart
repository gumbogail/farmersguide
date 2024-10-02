import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:farmersguide/stormresult.dart'; // Adjust import if necessary

class CitySelectionStorm extends StatefulWidget {
  const CitySelectionStorm({super.key});

  @override
  _CitySelectionStormState createState() => _CitySelectionStormState();
}

class _CitySelectionStormState extends State<CitySelectionStorm> {
  final TextEditingController _cityController = TextEditingController();
  late double latitude;
  late double longitude;
  bool _isLoading = false;

  // Function to fetch coordinates based on city name
  Future<void> _getCoordinatesFromCity(String cityName) async {
    String apiKey =
        "2381429f64d640a29be0e24e30de2372"; // Replace with your API key
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$cityName&key=$apiKey');

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var results = data['results'][0]['geometry'];
        latitude = results['lat'];
        longitude = results['lng'];

        // Send the real latitude and longitude to the storm prediction model (FastAPI)
        await _sendCoordinatesToModel(latitude, longitude);
      } else {
        _showErrorSnackbar(
            "Error fetching coordinates: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackbar("Error fetching coordinates: $e");
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  // Function to send the coordinates to FastAPI for storm predictions
  Future<void> _sendCoordinatesToModel(
      double latitude, double longitude) async {
    final url = Uri.parse('https://storm-models.onrender.com/predict/');

    Map<String, dynamic> body = {
      'latitude': latitude,
      'longitude': longitude,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        var predictionData = json.decode(response.body);

        if (kDebugMode) {
          print("Storm prediction received: ${response.body}");
        }

        // Navigate to PredictionStorm page with the prediction data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionStorm(
              latitude: latitude,
              longitude: longitude,
              stormOccurrence: predictionData['storm_occurrence'],
              stormSeverity: predictionData['storm_severity'],
              rainfallForecast: predictionData['rainfall_forecast'],
            ),
          ),
        );
      } else if (response.statusCode == 422) {
        _showErrorSnackbar("Error 422: Unprocessable Entity");
      } else {
        _showErrorSnackbar("Error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackbar("Error sending coordinates to model: $e");
    }
  }

  // Show an error message to the user using a snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                } else {
                  _showErrorSnackbar("City name cannot be empty");
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
