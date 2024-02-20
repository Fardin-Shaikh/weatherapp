import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:weatherapp/fetch/fetch.dart';
import 'package:weatherapp/global_w/toast.dart';
import 'package:weatherapp/models/current_weather.dart';
import 'package:weatherapp/models/forcast.dart';

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

  @override
  initState() {
    getStart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentWeather != null
              ? _buildWeatherWidget(context)
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildWeatherWidget(BuildContext context) {
    String? cityName = _currentWeather!.name; //city name
    int? currTemp = kelvinToCelsius(_currentWeather!.main!.tempMin)
        .toInt(); // current temperature
    int? currWind = _currentWeather!.wind!.speed!.toInt(); // current wind speed
    int? currHumidity = _currentWeather!.main!.humidity; // current wind speed
    int? currPressure = _currentWeather!.main!.pressure; // current wind speed
    int? currCloud = _currentWeather!.clouds!.all; // current wind speed
    // current wind speed
    int maxTemp = kelvinToCelsius(_currentWeather!.main!.tempMax)
        .toInt(); // today max temperature
    int minTemp = kelvinToCelsius(_currentWeather!.main!.tempMin)
        .toInt(); // today min temperature
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final RouteSettings settings = ModalRoute.of(context)!.settings;
    final data = settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      drawer: Drawer(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                accountName: Text(''),
                accountEmail: Text(data['user_email']),
                // accountEmail: Text('data['),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Favourale City',
                style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.bold),
              ),
              leading: Icon(
                Icons.location_city,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                'Konkan Division',
                style: GoogleFonts.questrial(
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                  fontSize: size.height * 0.025,
                ),
              ),
              onTap: () {
                setState(() {
                  isLoading = true;
                });

                final mumbail_pos = Position(
                  longitude: 72.87,
                  latitude: 19.07,
                  timestamp: DateTime.now(),
                  accuracy: 100,
                  altitude: 10,
                  altitudeAccuracy: 3,
                  heading: 45,
                  headingAccuracy: 2,
                  speed: 2,
                  speedAccuracy: 1,
                );

                Fetch.insta.weatherNow(mumbail_pos).then((nowWeather) {
                  setState(() {
                    isLoading = false;
                    if (nowWeather != null) {
                      _currentWeather = nowWeather;
                    }
                  });
                });
                Fetch.insta.weatherForcast(mumbail_pos).then((forcastWeather) {
                  setState(() {
                    isLoading = false;
                    if (forcastWeather != null) {
                      _forcastWeather = forcastWeather;
                    }
                  });
                });
              },
              leading: Icon(
                Icons.pin_drop,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                'Jafarpur',
                style: GoogleFonts.questrial(
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                  fontSize: size.height * 0.025,
                ),
              ),
              leading: Icon(
                Icons.pin_drop,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onTap: () {
                setState(() {
                  isLoading = true;
                });

                final kolkata_pos = Position(
                  longitude: 88.15,
                  latitude: 22.30,
                  timestamp: DateTime.now(),
                  accuracy: 100,
                  altitude: 10,
                  altitudeAccuracy: 3,
                  heading: 45,
                  headingAccuracy: 2,
                  speed: 2,
                  speedAccuracy: 1,
                );

                Fetch.insta.weatherNow(kolkata_pos).then((nowWeather) {
                  setState(() {
                    isLoading = false;
                    if (nowWeather != null) {
                      _currentWeather = nowWeather;
                    }
                  });
                });
                Fetch.insta.weatherForcast(kolkata_pos).then((forcastWeather) {
                  setState(() {
                    isLoading = false;
                    if (forcastWeather != null) {
                      _forcastWeather = forcastWeather;
                    }
                  });
                });
              },
            ),
            ListTile(
                title: Text(
                  'Bhandara',
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    fontSize: size.height * 0.025,
                  ),
                ),
                leading: Icon(
                  Icons.pin_drop,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  final ngp_pos = Position(
                    longitude: 79.84,
                    latitude: 21.08,
                    timestamp: DateTime.now(),
                    accuracy: 73.67,
                    altitude: 15.36,
                    altitudeAccuracy: 3,
                    heading: 45,
                    headingAccuracy: 2,
                    speed: 2,
                    speedAccuracy: 1,
                  );

                  Fetch.insta.weatherNow(ngp_pos).then((nowWeather) {
                    setState(() {
                      isLoading = false;
                      if (nowWeather != null) {
                        _currentWeather = nowWeather;
                      }
                    });
                  });
                  Fetch.insta.weatherForcast(ngp_pos).then((forcastWeather) {
                    setState(() {
                      isLoading = false;
                      if (forcastWeather != null) {
                        _forcastWeather = forcastWeather;
                      }
                    });
                  });
                }),
            ListTile(
                title: Text(
                  'Your Location',
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                    fontSize: size.height * 0.025,
                  ),
                ),
                leading: Icon(
                  Icons.pin_drop,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  _getCurrentLocation().then((value) {
                    Fetch.insta.weatherNow(value).then((nowWeather) {
                      setState(() {
                        isLoading = false;
                        if (nowWeather != null) {
                          _currentWeather = nowWeather;
                        }
                      });
                    });
                    Fetch.insta.weatherForcast(value).then((forcastWeather) {
                      setState(() {
                        isLoading = false;
                        if (forcastWeather != null) {
                          _forcastWeather = forcastWeather;
                        }
                      });
                    });
                  });
                }),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: GoogleFonts.questrial(
            color: const Color(0xff1D1617),
            fontSize: size.height * 0.02,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, "/login");
                showToast(message: "Successfully signed out");
              },
              icon: const Icon(
                Icons.login_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: _currentWeather == null
          ? const Center(child: CircularProgressIndicator())
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
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                            ),
                            child: Align(
                              child: Text(
                                cityName!,
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
                                _currentWeather!.weather?[0].description! ??
                                    "..", // weather
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
                                            Text('Temperature: $currTemp ˚C',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.024,
                                                )),
                                            SizedBox(width: size.width * 0.03),
                                            Text('Humidity: $currHumidity%',
                                                style: GoogleFonts.questrial(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: size.height * 0.024,
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
                                            Text('Cloud: $currCloud',
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
                                            Text('Pressure: $currPressure hPa',
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
                                            Text('Wind Speed: $currWind m/s',
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
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  buildSevenDayForecastHead(
                                      "Days ", size, isDarkMode),
                                  _forcastWeather == null
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : SizedBox(
                                          height: size.height * 0.5,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                size.width * 0.005),
                                            child: ListView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: [
                                                Column(
                                                  children:
                                                      List.generate(7, (index) {
                                                    final dlist =
                                                        _forcastWeather!
                                                                .forecast!
                                                                .forecastday![
                                                            index + 1];
                                                    return buildSevenDayForecast(
                                                      dateTODay(dlist.date!),
                                                      dlist.day!.mintempC!
                                                          .toInt(),
                                                      dlist.day!.maxtempC!
                                                          .toInt(),
                                                      dlist.day!
                                                          .dailyChanceOfRain!,
                                                      size,
                                                      isDarkMode,
                                                    );
                                                  }),
                                                ),
                                              ],
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
    );
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

  Widget buildSevenDayForecast(
      String time, int minTemp, int maxTemp, int rain, size, bool isDarkMode) {
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
                child: Text(
                  '$rain %',
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: size.height * 0.025,
                  ),
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

  Widget buildSevenDayForecastHead(String head, size, bool isDarkMode) {
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
                  head,
                  style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.height * 0.025,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  FontAwesomeIcons.cloudRain,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.temperatureLow,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: size.height * 0.03,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.temperatureHigh,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: size.height * 0.03,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          )
          // Divider(
          //   color: isDarkMode ? Colors.white : Colors.black,
          // ),
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
        });
        Fetch.insta.weatherNow(position).then((nowWeather) {
          setState(() {
            isLoading = false;
            if (nowWeather != null) {
              _currentWeather = nowWeather;
            }
          });
        });
        Fetch.insta.weatherForcast(position).then((forcastWeather) {
          setState(() {
            isLoading = false;
            if (forcastWeather != null) {
              _forcastWeather = forcastWeather;
            }
          });
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

  void getStart() {
    _getLocation();
  }

  Future<CurrentWeather?> fetchCurrentWeatherData(
      String lat, String long) async {
    try {
      const apiKey = '085b4ec3049cb4c6d33fa15c173974a3';
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&appid=$apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        setState(() {
          _currentWeather = CurrentWeather.fromJson(jsonData);

          // forcastweatherData(pos!);
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

  String dateTODay(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime).substring(0, 3);
  }

  double kelvinToCelsius(double? k) {
    return k! - 273.15;
  }

  Future<Position> _getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      try {
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        log('Error getting location: $e');
        rethrow;
      }
    } else {
      await Permission.location.request();
      try {
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        log('Error getting location: $e');
        rethrow;
      }
    }
  }


}
