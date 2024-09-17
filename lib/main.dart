import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weatherdata.dart'; // Prediction page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Prediction App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CitySelectionPage(),
    );
  }
}

class CitySelectionPage extends StatefulWidget {
  const CitySelectionPage({super.key});

  @override
  _CitySelectionPageState createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends State<CitySelectionPage> {
  final TextEditingController _cityController = TextEditingController();
  late double latitude;
  late double longitude;

  Future<void> _getCoordinatesFromCity(String cityName) async {
    String apiKey = "2381429f64d640a29be0e24e30de2372"; // Use your API key here
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$cityName&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var results = data['results'][0]['geometry'];
        latitude = results['lat'];
        longitude = results['lng'];

        // Navigate to the Prediction Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionPage(
              latitude: latitude,
              longitude: longitude,
            ),
          ),
        );
      } else {
        print("Error fetching coordinates: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching coordinates: $e");
    }
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
