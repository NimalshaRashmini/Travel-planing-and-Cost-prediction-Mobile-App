import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CostPredictionPage extends StatefulWidget {
  @override
  _CostPredictionPageState createState() => _CostPredictionPageState();
}

class _CostPredictionPageState extends State<CostPredictionPage> {
  String _selectedCountry = '';
  List<String> _selectedPreferences = [];
  int _days = 7;
  int _travelers = 2;
  String _selectedPackage = '';

  double? _predictedCost;
  double? _totalCost;

  final List<String> _countries = ['Malaysia', 'Thailand', 'Singapore'];
  final List<String> _preferences = [
    'Beach',
    'Adventure',
    'Cultural',
    'Nature',
    'Shopping'
  ];
  final List<String> _packages = ['Budget', 'Mid-Range', 'Premium'];

  // Function to call the Flask API backend
  Future<void> _onPredict() async {
    if (_selectedCountry.isEmpty ||
        _selectedPackage.isEmpty ||
        _selectedPreferences.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select all options'),
      ));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://172.20.10.2:5001/predict'), // Ensure correct API endpoint(hange this to)
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'country': _selectedCountry,
          'preferences': _selectedPreferences,
          'days': _days,
          'travelers': _travelers,
          'package': _selectedPackage,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        double predictedCost = result['cost_per_person_lkr'];
        double totalCost = predictedCost * _travelers;

        setState(() {
          _predictedCost = predictedCost;
          _totalCost = totalCost;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Failed to get prediction. Server responded with code ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred while getting prediction'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Travel Cost Prediction'),
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

            // Select Preferences Checkboxes
            SizedBox(height: 20),
            _buildInputContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Travel Preferences',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                  ..._preferences.map((preference) {
                    return CheckboxListTile(
                      title: Text(
                        preference,
                        style: TextStyle(color: Colors.indigo[900]),
                      ),
                      value: _selectedPreferences.contains(preference),
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedPreferences.add(preference);
                          } else {
                            _selectedPreferences.remove(preference);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
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

            // Select Package Dropdown
            SizedBox(height: 20),
            _buildInputContainer(
              DropdownButton<String>(
                hint: Text('Select Travel Package',
                    style: TextStyle(color: Colors.indigo[900])),
                value: _selectedPackage.isEmpty ? null : _selectedPackage,
                onChanged: (value) {
                  setState(() {
                    _selectedPackage = value!;
                  });
                },
                items: _packages.map((package) {
                  return DropdownMenuItem(
                    value: package,
                    child: Text(
                      package,
                      style: TextStyle(color: Colors.indigo[900]),
                    ),
                  );
                }).toList(),
                isExpanded: true,
                dropdownColor: Colors.blue[50],
              ),
            ),

            // Predict Button
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _onPredict,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, color: Colors.white),
                ),
                child: Text('Predict'),
              ),
            ),

            // Display Results
            SizedBox(height: 20),
            if (_predictedCost != null && _totalCost != null) ...[
              _buildResultText(
                'Predicted cost per person (LKR): Rs ${_predictedCost!.toStringAsFixed(2)}',
              ),
              _buildResultText(
                'Total cost for $_travelers travelers (LKR): Rs ${_totalCost!.toStringAsFixed(2)}',
              ),
            ],
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

  // Helper method to build result text
  Widget _buildResultText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.indigo[900],
      ),
    );
  }
}
