import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StormNotificationPage extends StatefulWidget {
  final String location; // Can be passed from home page

  const StormNotificationPage({super.key, required this.location});

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
      Uri.parse('https://storm-models.onrender.com/predict_today/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'location': widget.location, // Pass location for prediction
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      int stormOccurrence = data['storm_occurrence_today'];
      int stormSeverity = data['storm_severity_today'];

      if (stormOccurrence == 1 && stormSeverity == 0) {
        setState(() {
          message = "No storm, just rain.";
        });
      } else if (stormOccurrence == 0 && stormSeverity == 0) {
        setState(() {
          message = "All clear, no storm.";
        });
      } else if (stormSeverity == 1) {
        setState(() {
          message = "Mild storm, stay safe.";
        });
      } else if (stormSeverity == 2) {
        setState(() {
          message = "Severe storm, be cautious!";
        });
      } else if (stormSeverity == 3) {
        setState(() {
          message = "Extreme storm, take immediate action!";
        });
      }
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
        child: Text(
          message,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
