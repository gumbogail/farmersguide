import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PredictionStorm extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const PredictionStorm(
      {super.key, required this.latitude, required this.longitude});

  @override
  // ignore: library_private_types_in_public_api
  _PredictionStormState createState() => _PredictionStormState();
}

class _PredictionStormState extends State<PredictionStorm> {
  List<Map<String, dynamic>> _threeMonthPredictions = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchThreeMonthPredictions();
  }

  // Fetches prediction data for the next three months
  Future<void> _fetchThreeMonthPredictions() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://storm-models.onrender.com/predict_next_three_months?latitude=${widget.latitude}&longitude=${widget.longitude}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _threeMonthPredictions = List<Map<String, dynamic>>.from(data);
          });
        } else {
          _setError('Unexpected data format from server.');
        }
      } else {
        _setError('Error fetching 3-month predictions: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Error fetching 3-month predictions.');
      if (kDebugMode) {
        print('Error fetching 3-month predictions: $e');
      }
    }
  }

  void _setError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  // Converts month number to month name
  String _getMonthName(dynamic month) {
    int monthInt = (month is double) ? month.toInt() : month;
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[monthInt - 1];
  }

  // Gets the severity of the storm based on the occurrence and severity values
  String _getSeverityText(dynamic occurrence, dynamic severity) {
    int occurrenceInt =
        (occurrence is double) ? occurrence.toInt() : occurrence;
    int severityInt = (severity is double) ? severity.toInt() : severity;

    if (occurrenceInt == 1) {
      switch (severityInt) {
        case 1:
          return 'Mild Storm';
        case 2:
          return 'Severe Storm';
        case 3:
          return 'Extreme Storm';
        default:
          return 'Unknown severity';
      }
    } else {
      return 'No storm conditions';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storm Prediction Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage))
            : _threeMonthPredictions.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _threeMonthPredictions.length,
                    itemBuilder: (context, index) {
                      final prediction = _threeMonthPredictions[index];
                      final monthName = _getMonthName(prediction['month']);
                      final severityText = _getSeverityText(
                        prediction['storm_occurrence'],
                        prediction['storm_severity'],
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            monthName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            severityText,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
