import 'package:farmersguide/alerts.dart';
import 'package:farmersguide/droughtdatafetch.dart';
import 'package:farmersguide/insights.dart';
import 'package:farmersguide/stormfetchdata.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const HomePage({super.key, required this.latitude, required this.longitude});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize the pages with appropriate arguments
    _pages = <Widget>[
      _homeContent(), // Home content page with grid view
      const CitySelectionStorm(), // Storm Forecast Page
      const HotTips(
        rainfallForecast: [],
      ), // Insights Page
      CitySelection(
          latitude: widget.latitude,
          longitude: widget.longitude), // Drought Forecast Page
    ];
  }

  // Handle BottomNavigationBar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method to build the home content page with GridView
  Widget _homeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Wrap in SingleChildScrollView
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: [
            // "Hey there!" text at the top of the page
            const Padding(
              padding:
                  EdgeInsets.only(bottom: 16.0), // Add space below the text
              child: Text(
                'Hey there!',
                style: TextStyle(
                  fontSize: 24, // Set the font size
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
            ),
            // Top two cards inside a GridView with fixed height
            SizedBox(
              height: 200, // Give fixed height to GridView
              child: GridView.count(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 2, // Space between rows
                childAspectRatio: 1.0, // Control card aspect ratio
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3; // Navigate to Drought Forecast
                      });
                    },
                    child: const Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wb_sunny, size: 50, color: Colors.orange),
                          SizedBox(height: 10),
                          Text('Drought Forecast',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1; // Navigate to Hot Tips (Insights)
                      });
                    },
                    child: const Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storm,
                            size: 50,
                            color: Colors.blue, // Icon color
                          ),
                          SizedBox(height: 10),
                          Text('Storm forecast',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom "Hot tip!" card filling horizontally with less space
            Container(
              width: double.infinity, // Make the card fill horizontally
              height: 120, // Adjust height as needed
              margin: const EdgeInsets.only(
                  top: 2), // Reduced margin to tighten spacing
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2; // Navigate to Hot Tip
                  });
                },
                child: const Card(
                  color: Colors.black, // Change card color to black
                  elevation: 4, // Card shadow
                  child: Padding(
                    padding:
                        EdgeInsets.all(16.0), // Add padding inside the card
                    child: Row(
                      // Use Row to make the card horizontal
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.light,
                          size: 60, // Adjust the icon size
                          color: Colors.yellow, // Icon color
                        ),
                        SizedBox(width: 20), // Space between icon and text
                        Expanded(
                          // Expand the text to take available space
                          child: Text(
                            'Hot tip!',
                            style: TextStyle(
                              fontSize: 20, // Increase font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text on black card
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StormNotificationPage(
                        latitude: 0.0, longitude: 0.0)),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Change page on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storm, color: Colors.black),
            label: 'Storm Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb, color: Colors.black),
            label: 'Hot Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny, color: Colors.black),
            label: 'Drought Forecast',
          ),
        ],
      ),
    );
  }
}
