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
      _homeContent(), // Home content page with buttons
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

  // Method to build the home content page
  Widget _homeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Storm Forecast'),
            onTap: () {
              setState(() {
                _selectedIndex = 1; // Navigate to Storm Forecast
              });
            },
            leading: const Icon(Icons.storm),
          ),
          const Divider(),
          ListTile(
            title: const Text('Drought Forecast'),
            onTap: () {
              setState(() {
                _selectedIndex = 3; // Navigate to Drought Forecast
              });
            },
            leading: const Icon(Icons.wb_sunny),
          ),
          const Divider(),
          ListTile(
            title: const Text('Hot Tips'),
            onTap: () {
              setState(() {
                _selectedIndex = 2; // Navigate to Hot Tips (Insights)
              });
            },
            leading: const Icon(Icons.lightbulb),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                  color: Colors.black), // Notification Bell
              label: 'Notifications'),
        ],
      ),
    );
  }
}
