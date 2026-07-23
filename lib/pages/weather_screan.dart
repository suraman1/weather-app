import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/data/city_names.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/additional_info.dart';
import 'package:weather_app/widgets/hourly_info.dart';

class WeatherScrean extends StatefulWidget {
  const WeatherScrean({super.key});

  @override
  State<WeatherScrean> createState() => _WeatherScreanState();
}

class _WeatherScreanState extends State<WeatherScrean> {
  late Future<void> _weather;
  final cities = CityNames.cities;
  @override
  void initState() {
    super.initState();
    _weather = context.read<WeatherService>().fetchWeather();
  }

  Future<void> _refresh() async {
    setState(() {
      _weather = context.read<WeatherService>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherService>();

    final data = weatherProvider.weatherData;
    final forcast = weatherProvider.forcastData;
    return FutureBuilder(
      future: _weather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F6FA),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Loading weather...',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return RefreshIndicator(
            color: Colors.blue,
            onRefresh: () async {
              await _refresh();
            },
            child: Scaffold(
              backgroundColor: const Color(0xFFF6F6FA),
              body: Center(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Connect to mobile data or wifi',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const Text(
                        'And refresh this page',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          DateTime now = DateTime.now();
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Weather App',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await weatherProvider.fetchWeather();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),

            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Today',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${now.day}-${now.month.toString().padLeft(2, '0')}-${now.year}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: DropdownButton(
                          isExpanded: false,
                          hint: const Text('Select city'),
                          value: weatherProvider.currentCity,
                          items: cities.map<DropdownMenuItem<String>>((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(
                                city,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (city) async {
                            await weatherProvider.saveCurrentCity(city.toString());
                            await weatherProvider.fetchWeather();
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),

                          child: Column(
                            children: [
                              Text(
                                '${data['main']['temp'].round()}°',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              getWeatherIcon(data['weather'][0]['main']),
                              const SizedBox(height: 16),
                              Text(
                                data['weather'][0]['description'],
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // each card
                    const Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(forcast.length, (index) {
                          final hourlyForcasts = forcast[index];
                          return HourlyForcastItem(
                            time: hourlyForcasts['dt_txt'].substring(11, 16),
                            icon: getWeatherIcon(
                              hourlyForcasts['weather'][0]['main'],
                            ),
                            temprature:
                                '${hourlyForcasts['main']['temp'].round()}°',
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),
                    // last addtional info
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItem(
                          icon: Icon(Icons.water_drop, color: Colors.blue),
                          label: 'Humidity',
                          value: '${data['main']['humidity']}',
                        ),
                        AdditionalInfoItem(
                          icon: Icon(Icons.air, color: Colors.teal),
                          label: 'Wind Speed',
                          value: '${data['wind']['speed']}',
                        ),
                        AdditionalInfoItem(
                          icon: Icon(Icons.speed, color: Colors.orange),
                          label: 'Pressure',
                          value: '${data['main']['pressure']}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Icon getWeatherIcon(String weather) {
    return Icon(
      switch (weather) {
        'Clear' => Icons.wb_sunny,
        'Clouds' => Icons.cloud,
        'Rain' => Icons.umbrella,
        'Snow' => Icons.ac_unit,
        'Thunder storm' => Icons.flash_on,
        _ => Icons.cloud,
      },
      size: 70,
      color: switch (weather) {
        'Clear' => Colors.amber,
        'Clouds' => Colors.blueGrey,
        'Rain' => Colors.blue,
        'Snow' => Colors.lightBlueAccent,
        'Thunder storm' => Colors.deepPurple,
        _ => Colors.grey,
      },
    );
  }
}
