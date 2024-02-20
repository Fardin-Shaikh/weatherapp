import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/auth/firebase_auth_services.dart';
import 'package:weatherapp/global_w/form_container_widget.dart';
import 'package:weatherapp/global_w/toast.dart';

class FormPage extends StatefulWidget {
  final bool islogin;
  FormPage({required this.islogin});
  @override
  State<FormPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<FormPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool _isLoading = false;
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "Required"),
    EmailValidator(errorText: "Enter valid email id"),
  ]);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.islogin ? 'Login' : 'Sign Up',
              style: GoogleFonts.questrial(
                // color: isDarkMode ? Colors.white54 : Colors.black54,
                fontSize: size.height * 0.04,
              )),
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
                    SizedBox(height: size.height * 0.07),
                    Image.asset(
                      'lib/assets/logo.png',
                      width: size.width * 0.5,
                    ),
                    Text(
                      'Weather App',
                      style: GoogleFonts.questrial(
                        // color: isDarkMode ? Colors.white54 : Colors.black54,
                        fontSize: size.height * 0.025,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    FormContainerWidget(
                      controller: emailController,
                      hintText: "Email",
                      isPasswordField: false,
                      validator: emailValidator,
                    ),
                    SizedBox(height: size.height * 0.03),
                    FormContainerWidget(
                        controller: passwordController,
                        hintText: widget.islogin ? "Password" : "Set Password",
                        isPasswordField: true,
                        validator: widget.islogin
                            ? RequiredValidator(
                                errorText: 'password is required')
                            : passwordValidator),
                    SizedBox(height: size.height * 0.03),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.islogin) {
                            _signIn();
                          } else {
                            _signUp();
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(widget.islogin ? 'Login' : 'Sign Up',
                                  // style: TextStyle(
                                  //   color: Colors.white,
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                  style: GoogleFonts.questrial(
                                    color: Colors.white,
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    TextButton(
                      onPressed: () {
                        if (widget.islogin) {
                          Navigator.pushNamed(context, '/signup');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                          widget.islogin
                              ? 'Don\'t have an account? Sign up'
                              : 'Already have an account? Log in',
                          style: GoogleFonts.questrial(
                            // color: isDarkMode ? Colors.white54 : Colors.black54,
                            fontSize: size.height * 0.023,
                          )),
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

  void _signIn() async {
    setState(() {
      _isLoading = true;
    });

    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim().toLowerCase();

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    log(user.toString());
    setState(() {
      _isLoading = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (Route<dynamic> route) => false,
          arguments: {'user_email': emailController.text.trim()});
    } else {
      showToast(message: "Invalid email or password.");
    }
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    // String username = _usernameController.text;
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim().toLowerCase();

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushNamedAndRemoveUntil(
          context, "/dashboard", (Route<dynamic> route) => false,
          arguments: {'user_email': emailController.text.trim()});
    } else {
      showToast(message: "Some error happend");
    }
  }
}
