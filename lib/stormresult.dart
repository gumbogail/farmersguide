import 'package:farmersguide/insights.dart';
import 'package:flutter/material.dart';

class PredictionStorm extends StatelessWidget {
  final double latitude;
  final double longitude;
  final int stormOccurrence;
  final String stormSeverity;
  final List<dynamic> rainfallForecast;

  const PredictionStorm({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.stormOccurrence,
    required this.stormSeverity,
    required this.rainfallForecast,
  });

  // Helper function to get month names
  String getMonthName(int monthIndex) {
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
    return monthNames[monthIndex % 12];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storm Prediction Results"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Storm Occurrence: ${stormOccurrence == 1 ? 'Yes' : 'No'}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "Storm Severity: $stormSeverity",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        stormSeverity == "No Storm" ? Colors.green : Colors.red,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Rainfall Forecast:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: rainfallForecast.length,
                itemBuilder: (context, index) {
                  // Map forecast to months
                  String monthName = getMonthName(DateTime.now().month + index);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: const Icon(
                        Icons.water_drop,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        monthName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${rainfallForecast[index].toStringAsFixed(2)} mm",
                        style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Add a button to navigate to the InsightsPage
            // Button to navigate to the HotTips page
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotTips(
                        rainfallForecast: rainfallForecast
                            .map((e) => e as double)
                            .toList(), // Ensure casting to double
                      ),
                    ),
                  );
                },
                child: const Text('Go to Insights'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
