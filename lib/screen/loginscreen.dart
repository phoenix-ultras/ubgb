import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubgb/screen/homescreen.dart';

final _kfirebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenheight = 0;
  double screenwidth = 0;

  String _enteredUsername = '';
  String _enteredPass = '';
  final _formkey = GlobalKey<FormState>();
  var snap;
  bool isObscure = true;

  void _login() async {
    //validation
    final isValid = _formkey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formkey.currentState!.save();
    //login authentication
    try {
      if (isValid) {
        await _kfirebase.signInWithEmailAndPassword(
            email: _enteredUsername, password: _enteredPass);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Homescreen()));
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 153, 15, 5),
          behavior: SnackBarBehavior.floating,
          content: Text(
            error.message ?? 'Authentication Failed',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Color.fromARGB(255, 153, 15, 5),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Please enter correct username and password',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bd.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              top: 250,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 380,
                width: MediaQuery.of(context).size.width - 40,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 3),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.brown.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 2,
                      width: 55,
                      color: Colors.amber.shade600,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          //Username Container
                          Container(
                            margin:
                                EdgeInsets.only(top: 30, left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      spreadRadius: 1)
                                ],
                                color: Colors.grey.shade100.withOpacity(.2),
                                borderRadius: BorderRadius.circular(15)),

                            //Username field
                            child: TextFormField(
                              onSaved: (newValue) {
                                _enteredUsername = newValue!;
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  //show message upon correct validation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Invalid Username')));
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          //password Container
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      spreadRadius: 1)
                                ],
                                color: Colors.grey.shade100.withOpacity(.2),
                                borderRadius: BorderRadius.circular(10)),

                            //Password Field
                            child: TextFormField(
                              onSaved: (newValue) {
                                _enteredPass = newValue!;
                              },
                              obscureText: isObscure,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length < 2) {
                                  //  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Invalid Password')));
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: isObscure
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                  color: const Color(0xff02c38e),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          //
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 580,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: _login,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 6,
                              spreadRadius: 1)
                        ],
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
