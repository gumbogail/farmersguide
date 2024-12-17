import 'package:flutter/material.dart';

class HotTips extends StatelessWidget {
  final List<double> rainfallForecast;

  const HotTips({
    super.key,
    required this.rainfallForecast,
  });

  String generateTip() {
    // Check if rainfallForecast is empty
    if (rainfallForecast.isEmpty) {
      return "No rainfall data available. Please enter location again.";
    }

    // Calculate the average rainfall
    double averageRainfall =
        rainfallForecast.reduce((a, b) => a + b) / rainfallForecast.length;

    if (averageRainfall < 50) {
      return "The next three months are expected to be quite dry. \n\n- Plant drought-resistant crops like millet or sorghum.\n- Use mulching to conserve soil moisture.\n- Irrigate your fields if possible to support early growth.";
    } else if (averageRainfall >= 50 && averageRainfall <= 100) {
      return "Moderate rainfall is expected. \n\n- This is ideal for planting maize. Start preparing your fields now.\n- Ensure your fields have proper drainage to prevent waterlogging.\n- Consider adding organic compost to improve soil fertility.";
    } else {
      return "Heavy rainfall is predicted for the coming months. \n\n- Focus on planting maize varieties that can handle excess water.\n- Install proper drainage systems to avoid flooding.\n- Protect young plants with raised beds or ridges to keep roots dry.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate a farming tip
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
            // const Text(
            //   'Rainfall Predictions (Next 3 Months):',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // // Show rainfall data if available
            // if (rainfallForecast.isNotEmpty)
            //   for (int i = 0; i < rainfallForecast.length; i++)
            //     ListTile(
            //       leading: const Icon(Icons.cloud, color: Colors.blueAccent),
            //       title: Text(
            //         'Month ${i + 1}: ${rainfallForecast[i].toStringAsFixed(2)} mm',
            //         style: const TextStyle(fontSize: 18),
            //       ),
            //     )
            // else
            //   const Text(
            //     'No rainfall data available.',
            //     style: TextStyle(fontSize: 18),
            //   ),
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
