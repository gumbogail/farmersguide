import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StormNotificationPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const StormNotificationPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  _StormNotificationPageState createState() => _StormNotificationPageState();
}

class _StormNotificationPageState extends State<StormNotificationPage> {
  String message = "Fetching storm status...";

  @override
  void initState() {
    super.initState();
    fetchStormStatus();
  }

  Future<void> fetchStormStatus() async {
    final response = await http.post(
      Uri.parse('https://storm-models-vnx8.onrender.com/predict/today/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': widget.latitude,
        'longitude': widget.longitude,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      int stormOccurrence = data['storm_occurrence'];
      String stormSeverity = data['storm_severity'];

      setState(() {
        message =
            "Storm Occurrence: $stormOccurrence\nStorm Severity: $stormSeverity";
      });
    } else {
      setState(() {
        message = "Failed to fetch storm status.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storm Notifications'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
