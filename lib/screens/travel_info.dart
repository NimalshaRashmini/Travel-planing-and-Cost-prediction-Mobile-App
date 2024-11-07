import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String _selectedCountry = '';
  int _days = 7;
  int _travelers = 2;
  DateTime _selectedDate = DateTime.now();
  String _travelPlan = '';

  final List<String> _countries = ['Malaysia', 'Thailand', 'Singapore'];

  // Function to call the Flask API backend
  Future<void> _onGenerateTravelPlan() async {
    if (_selectedCountry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a country')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://172.20.10.2:5002/generate-travel-plan'), //change ip for emulato
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'country': _selectedCountry,
          'travel_days': _days,
          'traveler_count': _travelers,
          'travel_date': _selectedDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _travelPlan = result['travel_plan'];
        });

        // Show the travel plan in a popup dialog
        _showTravelPlanDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to generate travel plan. Server responded with code ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while generating travel plan')),
      );
    }
  }

  // Function to display the travel plan in a popup dialog
  void _showTravelPlanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Generated Travel Plan"),
          content: SingleChildScrollView(
            child: Text(_travelPlan.isNotEmpty
                ? _travelPlan
                : "No travel plan available."),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to select a start date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Travel Plan Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Country Dropdown
            _buildInputContainer(
              DropdownButton<String>(
                hint: Text('Select Country',
                    style: TextStyle(color: Colors.indigo[900])),
                value: _selectedCountry.isEmpty ? null : _selectedCountry,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value!;
                  });
                },
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(
                      country,
                      style: TextStyle(color: Colors.indigo[900]),
                    ),
                  );
                }).toList(),
                isExpanded: true,
                dropdownColor: Colors.blue[50],
              ),
            ),

            // Travel Days Slider
            SizedBox(height: 20),
            _buildInputContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Travel Days: $_days',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                  Slider(
                    value: _days.toDouble(),
                    min: 3,
                    max: 21,
                    divisions: 18,
                    label: '$_days days',
                    activeColor: Colors.blue,
                    onChanged: (double value) {
                      setState(() {
                        _days = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),

            // Travelers Slider
            SizedBox(height: 20),
            _buildInputContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Travelers: $_travelers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                  Slider(
                    value: _travelers.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: '$_travelers travelers',
                    activeColor: Colors.blue,
                    onChanged: (double value) {
                      setState(() {
                        _travelers = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),

            // Select Start Date Button
            SizedBox(height: 20),
            _buildInputContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    ),
                    child: Text('Select start date',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

            // Generate Travel Plan Button
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _onGenerateTravelPlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, color: Colors.white),
                ),
                child: Text('Generate Travel Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a styled input container
  Widget _buildInputContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.indigo[900]!, width: 2.0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12.0),
      child: child,
    );
  }
}
