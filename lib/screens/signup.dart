import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:weatherapp/screens/dashboard.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // @override
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "* Required"),
    EmailValidator(errorText: "Enter valid email id"),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
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
                      validator: emailValidator,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Set Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: passwordValidator

                        // (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter your password';
                        //   }
                        //   if (value.length < 6) {
                        //     return 'Password must be at least 6 characters long';
                        //   }
                        //   return null;
                        // },
                        ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          signUpWithEmailAndPassword(
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
                          ? CircularProgressIndicator()
                          : Text('Sign Up'),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Already have an account? Log in'),
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

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {}
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('User Already Exist'),
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
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}

//   Future<void> _checkInternetConnection(BuildContext context) async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       // No internet connection
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('No Internet Connection'),
      //     content: Text('Please check your internet connection and try again.'),
      //     actions: <Widget>[
      //       TextButton(
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //         child: Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
//     } else {
//       setState(() {
//         _isLoading = true;
//       });

//       // Internet connection available, proceed with sign-up
//       if (_formKey.currentState!.validate()) {
//         signUpWithEmailAndPassword(
//           emailController.text.trim(),
//           passwordController.text.trim(),
//         ).then((value) {
//           if (value == null) {
//             log("inn");
//             setState(() {
//               _isLoading = false;
//             });
// //navigate
//           } else {
//             log("out");
//             showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: Text('some thing went wrong'),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               ),
//             );
//           }
//         });
//       }
//     }
//   }
// }
