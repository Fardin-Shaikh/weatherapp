import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/models/current_weather.dart';
import 'package:weatherapp/models/forcast_weather.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  CurrentWeather? _currentWeather;
  ForcastWeather? _forcastWeather;
  Position? pos;
  bool isLoading = false;
  bool isLoadingForcast = false;
  List<ListElement> sorted_list = [];

  @override
  initState() {
    maple();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentWeather != null
              ? _buildWeatherWidget(context)
              : Center(child: Text('No data')),
    );
  }

  Widget _buildWeatherWidget(BuildContext context) {
    String cityName = _currentWeather!.name; //city name
    int currTemp = _currentWeather!.main.temp.toInt(); // current temperature
    int currWind = _currentWeather!.wind.speed.toInt(); // current wind speed
    int currHumidity = _currentWeather!.main.humidity; // current wind speed
    int currPressure = _currentWeather!.main.pressure; // current wind speed
    int currCloud = _currentWeather!.clouds.all; // current wind speed
    // current wind speed
    int maxTemp =
        _currentWeather!.main.tempMax.toInt(); // today max temperature
    int minTemp =
        _currentWeather!.main.tempMin.toInt(); // today min temperature
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
        body: Center(
      child: _currentWeather == null
          ? CircularProgressIndicator()
          : Container(
              height: size.height,
              width: size.height,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01,
                              horizontal: size.width * 0.05,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // FaIcon(
                                //   FontAwesomeIcons.bars,
                                //   color: isDarkMode ? Colors.white : Colors.black,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      _getLocation();
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                Align(
                                  child: Text(
                                    'Weather App', //TODO: change app name
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.white
                                          : const Color(0xff1D1617),
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                                // FaIcon(
                                //   FontAwesomeIcons.plusCircle,
                                //   color: isDarkMode ? Colors.white : Colors.black,
                                // ),
                                IconButton(
                                    onPressed: () {
                                      final DateTime dateTime = DateTime.now();

                                      final DateFormat dateFormat =
                                          DateFormat('EEEE');

                                      String dayOfWeek =
                                          DateFormat('EEEE').format(dateTime);
                                      log(dayOfWeek);

                                      String dateTODay(DateTime dateTime) {
                                        return DateFormat('EEEE')
                                            .format(dateTime);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                            ),
                            child: Align(
                              child: Text(
                                cityName,
                                style: GoogleFonts.questrial(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: size.height * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.005,
                            ),
                            child: Align(
                              child: Text(
                                'Today', //day
                                style: GoogleFonts.questrial(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                  fontSize: size.height * 0.035,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                            ),
                            child: Align(
                              child: Text(
                                '$currTemp˚C', //curent temperature
                                style: GoogleFonts.questrial(
                                  color: currTemp <= 0
                                      ? Colors.blue
                                      : currTemp > 0 && currTemp <= 15
                                          ? Colors.indigo
                                          : currTemp > 15 && currTemp < 30
                                              ? Colors.deepPurple
                                              : Colors.pink,
                                  fontSize: size.height * 0.13,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.25),
                            child: Divider(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.005,
                            ),
                            child: Align(
                              child: Text(
                                _currentWeather!
                                    .weather[0].description, // weather
                                style: GoogleFonts.questrial(
                                  color: isDarkMode
                                      ? Colors.white54
                                      : Colors.black54,
                                  fontSize: size.height * 0.03,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                              bottom: size.height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$minTemp˚C', // min temperature
                                  style: GoogleFonts.questrial(
                                    color: minTemp <= 0
                                        ? Colors.blue
                                        : minTemp > 0 && minTemp <= 15
                                            ? Colors.indigo
                                            : minTemp > 15 && minTemp < 30
                                                ? Colors.deepPurple
                                                : Colors.pink,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                                Text(
                                  '/',
                                  style: GoogleFonts.questrial(
                                    color: isDarkMode
                                        ? Colors.white54
                                        : Colors.black54,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                                Text(
                                  '$maxTemp˚C', //max temperature
                                  style: GoogleFonts.questrial(
                                    color: maxTemp <= 0
                                        ? Colors.blue
                                        : maxTemp > 0 && maxTemp <= 15
                                            ? Colors.indigo
                                            : maxTemp > 15 && maxTemp < 30
                                                ? Colors.deepPurple
                                                : Colors.pink,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.black.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.01,
                                        left: size.width * 0.03,
                                      ),
                                      child: Text(
                                        'Forecast for today',
                                        style: GoogleFonts.questrial(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.050),
                                    child: Column(
                                      children: [
                                        SizedBox(height: size.height * 0.010),
                                        Row(
                                          children: [
                                            Text('Temperature: ${currTemp} ˚C',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.025,
                                                )),
                                            SizedBox(width: size.width * 0.050),
                                            Text('Humidity: ${currHumidity}%',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.025,
                                                )),
                                          ],
                                        ),

                                        SizedBox(height: size.height * 0.020),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.cloud,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            SizedBox(width: size.width * 0.030),
                                            Text('Cloud: ${currCloud}',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.025,
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.waves,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            SizedBox(width: size.width * 0.030),
                                            Text(
                                                'Pressure: ${currPressure} hPa',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.025,
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.020),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.air,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            SizedBox(width: size.width * 0.030),
                                            Text('Wind Speed: ${currWind} m/s',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.025,
                                                )),
                                          ],
                                        ),
                                        //TODO: change weather forecast from local to api get
                                        // buildForecastToday(
                                        //   "Now", //hour
                                        //   currTemp, //temperature
                                        //   currWind, //wind (km/h)
                                        //   currHumidity, //rain chance (%)
                                        //   FontAwesomeIcons
                                        //       .temperatureThreeQuarters, //weather icon
                                        //   size,
                                        //   isDarkMode,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.02,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.02,
                                        left: size.width * 0.03,
                                      ),
                                      child: Text(
                                        '7-day forecast',
                                        style: GoogleFonts.questrial(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  isLoadingForcast
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Container(
                                          color: Colors.amber,
                                          child: SizedBox(
                                            height: size.height * 0.5,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  size.width * 0.005),
                                              child: ListView.builder(
                                                // physics:
                                                //     NeverScrollableScrollPhysics(), // Disable scrolling
                                                itemCount: 4,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  _forcastWeather!.list
                                                      .sort((a, b) {
                                                    ListElement dateA = a;
                                                    ListElement dateB = b;

                                                    int dateComparison =
                                                        dateA.dt.day.compareTo(
                                                            dateB.dt.day);

                                                    if (dateComparison == 0) {
                                                      return 0;
                                                    } else {
                                                      if (!sorted_list
                                                          .contains(dateA)) {
                                                        sorted_list.add(dateA);
                                                        return -1;
                                                      } else {
                                                        return 1;
                                                      }
                                                    }
                                                  });

                                                  return buildSevenDayForecast(
                                                    dateTODay(
                                                        sorted_list[index].dt),
                                                    -5,
                                                    5,
                                                    FontAwesomeIcons.sun,
                                                    size,
                                                    isDarkMode,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    ));
  }

  Widget buildForecastToday(String time, int temp, int wind, int rainChance,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(
        children: [
          Text(
            time,
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$temp˚C',
            style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: size.height * 0.025,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  FontAwesomeIcons.wind,
                  color: Colors.grey,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$wind km/h',
            style: GoogleFonts.questrial(
              color: Colors.grey,
              fontSize: size.height * 0.02,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                ),
                child: FaIcon(
                  WeatherIcons.humidity,
                  color: Colors.blue,
                  size: size.height * 0.03,
                ),
              ),
            ],
          ),
          Text(
            '$rainChance %',
            style: GoogleFonts.questrial(
              color: Colors.blue,
              fontSize: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSevenDayForecast(String time, int minTemp, int maxTemp,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white38 : Colors.black38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }

//lOCATION
  Future<void> _getLocation() async {
    // Check if permission is granted
    setState(() {
      isLoading = true;
    });

    if (await Permission.location.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          pos = position;

          fetchCurrentWeatherData(position);
        });
      } catch (e) {
        log(e.toString());
      }
    } else {
      // Request permission if not granted
      await Permission.location.request();
      // Re-check if permission is granted after request
      if (await Permission.location.isGranted) {
        _getLocation();
      }
    }
  }

  void maple() {
    _getLocation();
  }

  Future<CurrentWeather> fetchCurrentWeatherData(Position position) async {
    try {
      final apiKey = '085b4ec3049cb4c6d33fa15c173974a3';
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        setState(() {
          _currentWeather = CurrentWeather.fromJson(jsonData);

          forcastweatherData(_currentWeather!.id);
        });
        return _currentWeather!;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<ForcastWeather> forcastweatherData(int location_id) async {
    try {
      setState(() {
        isLoadingForcast = true;
      });
      final apiKey = '4eac43d0cdeb912a2ab16d991a7ace79';
      final days = 30;

      final response = await http.get(Uri.parse(
          // 'http://api.openweathermap.org/data/2.5/forecast?id=${location_id}&appid=${apiKey}'));
          'http://api.openweathermap.org/data/2.5/forecast?id=${location_id}&cnt=${days}&appid=${apiKey}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        setState(() {
          _forcastWeather = ForcastWeather.fromJson(jsonData);
        });
        return _forcastWeather!;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    } finally {
      setState(() {
        isLoadingForcast = false;
      });
    }
  }

  String dateTODay(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }

  // Future<Position> _getCurrentLocation() async {
  //   if (await Permission.location.isGranted) {
  //     try {
  //       return await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //     } catch (e) {
  //       print('Error getting location: $e');
  //       throw e;
  //     }
  //   } else {
  //     await Permission.location.request();
  //     try {
  //       return await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high);
  //     } catch (e) {
  //       print('Error getting location: $e');
  //       throw e;
  //     }
  //   }
  // }

  //  buildSevenDayForecast(
  //                                               "Wed",
  //                                               -5,
  //                                               5,
  //                                               FontAwesomeIcons.sun,
  //                                               size,
  //                                               isDarkMode,
  //                                             ),
}
