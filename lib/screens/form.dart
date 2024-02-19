import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormPage extends StatefulWidget {
  final bool islogin;
  FormPage({required this.islogin});
  @override
  State<FormPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<FormPage> {
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
          title: Text(widget.islogin ? 'Login' : 'Sign Up'),
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
                          labelText:
                              widget.islogin ? 'Password' : 'Set Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: widget.islogin
                            ? RequiredValidator(
                                errorText: 'password is required')
                            : passwordValidator),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          if (widget.islogin) {
                            signInWithEmailAndPassword(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            ).then((user) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (user != null) {
                                // Navigator.pushReplacementNamed(
                                //     context, '/dashboard', arguments: {
                                //   'user_email': emailController.text.trim()
                                // });
                                Navigator.pushNamed(context, '/dashboard',
                                    arguments: {
                                      'user_email': emailController.text.trim()
                                    });
                              }
                            });
                          } else {
                            signUpWithEmailAndPassword(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            ).then((user) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (user != null) {
                                // Navigator.pushReplacementNamed(
                                //     context, '/dashboard', arguments: {
                                //   'user_email': emailController.text.trim()
                                // });
                                Navigator.pushNamed(context, '/dashboard',
                                    arguments: {
                                      'user_email': emailController.text.trim()
                                    });
                              }
                            });
                          }
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(widget.islogin ? 'Login' : 'Sign Up'),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        if (widget.islogin) {
                          Navigator.pushNamed(context, '/signup');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(widget.islogin
                          ? 'Don\'t have an account? Sign up'
                          : 'Already have an account? Log in'),
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

//login
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          log(value.user!.getIdToken().toString() + 'ldfalsdlfa00000000000');
          throw 'ceh';
        },
      );
      // Check if userCredential.user is null and handle accordingly
      ;
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
