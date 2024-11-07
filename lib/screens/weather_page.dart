import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:explore_sae/screens/consts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();

  void _fetchWeather() async {
    final cityName = _cityController.text;
    if (cityName.isNotEmpty) {
      Weather? weather = await _wf.currentWeatherByCityName(cityName);
      setState(() {
        _weather = weather;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Weather Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Input field with frame
              _buildInputContainer(
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'Enter City Name',
                          labelStyle: TextStyle(color: Colors.indigo[900]),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo[900]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _fetchWeather,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[900],
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text(
                        'Get Weather',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Weather display
              _buildUI(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return Center(
        child: Text(
          'Please enter a city to get the weather.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[900],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(height: 20),
          _dateTimeInfo(),
          SizedBox(height: 20),
          _weatherIcon(),
          SizedBox(height: 20),
          _weatherDescription(),
          SizedBox(height: 20),
          _currentTemp(),
          SizedBox(height: 20),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.indigo[900],
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w400,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        Text(
          DateFormat("EEEE, d MMM yyyy").format(now),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.indigo[900],
          ),
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Image.network(
      "https://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png",
      errorBuilder: (context, error, stackTrace) {
        return const Text('Could not load image');
      },
      width: 100,
      height: 100,
    );
  }

  Widget _weatherDescription() {
    return Text(
      _weather!.weatherDescription ?? "",
      style: TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        color: Colors.indigo[900],
      ),
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: TextStyle(
        fontSize: 90,
        fontWeight: FontWeight.w500,
        color: Colors.blue,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.indigo[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ],
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
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: child,
    );
  }
}
