import 'package:flutter/material.dart';

class HotTips extends StatelessWidget {
  final List<double> rainfallForecast;

  const HotTips({
    super.key,
    required this.rainfallForecast,
  });

  String generateTip() {
    double averageRainfall =
        rainfallForecast.reduce((a, b) => a + b) / rainfallForecast.length;

    if (averageRainfall < 50) {
      return "The next three months are expected to be quite dry. Consider using drought-resistant crops and irrigating your fields regularly.";
    } else if (averageRainfall >= 50 && averageRainfall <= 100) {
      return "Moderate rainfall is expected. Ensure your fields have proper drainage to avoid waterlogging and make the most of the rain.";
    } else {
      return "Heavy rainfall is predicted for the coming months. Focus on planting water-loving crops and ensure you have proper flood control measures.";
    }
  }

  @override
  Widget build(BuildContext context) {
    String farmingTip = generateTip();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Insights'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rainfall Predictions (Next 3 Months):',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < rainfallForecast.length; i++)
              ListTile(
                leading: const Icon(Icons.cloud, color: Colors.blueAccent),
                title: Text(
                  'Month ${i + 1}: ${rainfallForecast[i].toStringAsFixed(2)} mm',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Farming Tip:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Text(
                farmingTip,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
