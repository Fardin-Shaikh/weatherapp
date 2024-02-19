import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:weatherapp/screens/dashboard.dart';
import 'package:weatherapp/screens/form.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => FormPage(
              islogin: true,
            ),
        '/signup': (context) => FormPage(
              islogin: false,
            ),
        '/dashboard': (context) => DashBoard(),
      },
    );
  }
}
