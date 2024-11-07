import 'package:flutter/material.dart';
import 'side_panel.dart'; // Import SidePanel
import 'cost_prediction_page.dart'; // Import CostPredictionPage
import 'weather_page.dart'; // Import WeatherPage
import 'travel_info.dart'; // Import InfoPage

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Menu', style: TextStyle(color: Colors.white)),
      ),
      drawer: SidePanel(), // Add the side panel (drawer)
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message at the top
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Text(
                  'Hi there, welcome to explore with us!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),

              // Display image
              Image.asset(
                'assets/travel4.jpg', // Replace with your image path
                height: 350, // Adjust height
                width: 350, // Adjust width
                fit: BoxFit.contain,
              ),
              SizedBox(height: 50), // Space between image and icons

              // Row for icons (Cost, Weather, Travel)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cost Prediction Icon
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.attach_money,
                            size: 50, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CostPredictionPage()),
                          );
                        },
                      ),
                      Text(
                        'Cost',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Colors.indigo[900], // Dark blue color for label
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40), // Space between icons

                  // Weather Icon
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.cloud, size: 50, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WeatherPage()),
                          );
                        },
                      ),
                      Text(
                        'Weather',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Colors.indigo[900], // Dark blue color for label
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40), // Space between icons

                  // Travel Plan Icon
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.airplanemode_active,
                            size: 50, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InfoPage()),
                          );
                        },
                      ),
                      Text(
                        'Travel',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Colors.indigo[900], // Dark blue color for label
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
