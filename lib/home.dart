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
      const StormNotificationPage(
        latitude: 0.0,
        longitude: 0.0,
      ),
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
      child: GridView.count(
        crossAxisCount: 2, // Number of items per row
        crossAxisSpacing: 10, // Space between columns
        mainAxisSpacing: 10, // Space between rows
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 2; // Navigate to Hot Tips (Insights)
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Guide'),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Change page on tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storm, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Storm Forecast',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Hot Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Drought Forecast',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: Color.fromARGB(255, 0, 0, 0)), // Notification Bell
              label: 'Notifications'),
        ],
      ),
    );
  }
}
