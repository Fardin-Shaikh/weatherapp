

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:weatherapp/screens/dashboard.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/logo.png', // Your logo image path
                      width: 150.0,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          signInWithEmailAndPassword(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ).then((user) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  DashBoard()),
                              );
                            }
                          });
                        }
                      },
                      child: _isLoading
                          ? LinearProgressIndicator()
                          : Text('Login'),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        // Navigate to '/second' route
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Don\'t have an account? Sign up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//  Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       final userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       if (userCredential.user != null) {
//         log('not null');
//       } else {
//         log("null");
//       }
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided.');
//       }
//     }
//     return userCredential.user;
//   }
  // static Future<User?> signInUsingEmailPassword({
  //   required String email,
  //   required String password,
  // }) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;

  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     user = userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       log('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       log('Wrong password provided.');
  //     }
  //   }

  //   return user;
  // }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Check if userCredential.user is null and handle accordingly
      if (userCredential.user == null) {
        // Handle scenario where user is null after successful sign-in
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // Handle wrong password error
        print('The password provided is incorrect.');
        // Show a dialog or toast to notify the user about the wrong password
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Incorrect Password'),
            content:
                Text('The password provided is incorrect. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'user-not-found') {
        print('No user found for that email.');
      }
      // Handle other FirebaseAuthException errors here
    } catch (e) {
      print(e.toString());
      // Handle other generic exceptions here
    }
    return null;
  }
}
