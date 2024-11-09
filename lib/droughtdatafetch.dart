import 'dart:convert';
import 'package:farmersguide/droughtresuts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitySelection extends StatefulWidget {
  const CitySelection(
      {super.key, required double longitude, required double latitude});

  @override
  // ignore: library_private_types_in_public_api
  _CitySelectionState createState() => _CitySelectionState();
}

class _CitySelectionState extends State<CitySelection> {
  final TextEditingController _cityController = TextEditingController();
  late double latitude;
  late double longitude;
  bool _isLoading = false; // Loading state

  // Function to fetch coordinates based on city name
  Future<void> _getCoordinatesFromCity(String cityName) async {
    setState(() {
      _isLoading = true;
    });

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

        // Send the real latitude and longitude to the model (FastAPI)
        _sendCoordinatesToModel(latitude, longitude);

        // Navigate to the PredictionPage after fetching coordinates
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PredictionPage(latitude: latitude, longitude: longitude),
          ),
        );
      } else {
        _showErrorSnackbar("Error fetching coordinates");
      }
    } catch (e) {
      _showErrorSnackbar("Error fetching coordinates: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to send the coordinates to FastAPI for predictions
  Future<void> _sendCoordinatesToModel(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://drought-models-bedx.onrender.com/predict_next_three_months?latitude=$latitude&longitude=$longitude');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Prediction received");
        }
      } else {
        _showErrorSnackbar("Error: ${response.statusCode}");
      }
    } catch (e) {
      _showErrorSnackbar("Error sending coordinates to model: $e");
    }
  }

  // Function to show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select City"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      String city = _cityController.text;
                      if (city.isNotEmpty) {
                        _getCoordinatesFromCity(city);
                      } else {
                        _showErrorSnackbar("City name cannot be empty");
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
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
