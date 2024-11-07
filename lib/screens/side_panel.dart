import 'package:flutter/material.dart';
import 'auth_screen.dart'; // For logout
import 'cost_prediction_page.dart';
import 'weather_page.dart';
import 'travel_info.dart';

class SidePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Explore Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.attach_money, color: Colors.blue),
            title: Text('Cost Prediction'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CostPredictionPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.blue),
            title: Text('Weather'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WeatherPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_active, color: Colors.blue),
            title: Text('Travel Plan'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InfoPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
