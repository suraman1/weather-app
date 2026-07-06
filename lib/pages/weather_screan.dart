import 'package:flutter/material.dart';
import 'package:weather_app/widgets/additional_info.dart';
import 'package:weather_app/widgets/hourly_info.dart';


class WeatherScrean extends StatelessWidget {
  const WeatherScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle (
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              debugPrint('refresh');
            },
            icon: const Icon(Icons.refresh,),
          ),
        ],
      ),

      body: Padding (
        padding: const EdgeInsets.all(16.0),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox (
              width: double.infinity,
              child: Card (
                elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:
                  Padding(
                    padding: EdgeInsets.all(16),

                    child: Column(
                    children: [
                      Text('300K',
                      style: TextStyle(
                         fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      const SizedBox(height: 16,),
                      Icon(Icons.cloud, size: 64,),
                      const SizedBox(height: 16,),
                      Text('Rain', style: TextStyle(
                        fontSize: 20,
                      ),)
                    ],
                  ),
                  ),
              ),
            ),
            const SizedBox(height: 20,),
            // each card

              const Text(
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                    ),
              ),
            const SizedBox(height: 16,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForcastItem(
                    time: '00:00',
                    icon: Icons.cloud,
                    temprature: '301.22',
                  ),
                  HourlyForcastItem(
                    time: '03:00',
                    icon: Icons.sunny,
                    temprature: '352.22',
                  ),
                  HourlyForcastItem(
                    time: '06:00',
                    icon: Icons.cloud,
                    temprature: '302.22',
                  ),
                  HourlyForcastItem(
                    time: '09:00',
                    icon: Icons.cloud,
                    temprature: '304.22',
                  ),
                  HourlyForcastItem(
                    time: '12:00',
                    icon: Icons.cloud,
                    temprature: '302.22',
                  ),
                ],
              ),
            ),


            const SizedBox(height: 20,),
            // last addtional info
            const Text (
              'Additional Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '91',
                ),
                AdditionalInfoItem(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '7.5',
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1000',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





