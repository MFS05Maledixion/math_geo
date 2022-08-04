import 'package:flutter/material.dart';
import 'package:math_geometry/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String fullname = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(1, 227, 242, 218),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 40),
              Column(
                children: [
                  Text("Welcome back candidate"),
                  SizedBox(height: 20),
                  Image(
                    image: AssetImage('images/nxtminds.jpg'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Enter your username"),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(100, 255, 255, 255),
                          border: Border.all(
                              color: Color.fromARGB(25, 105, 105, 105)),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            fullname = val;
                          });
                        },
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey[300])),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Enter your password"),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(100, 255, 255, 255),
                          border: Border.all(
                              color: Color.fromARGB(25, 105, 105, 105)),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        obscureText: true,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[300])),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () => widget.toggleView(),
                        child: Text("Sign Up"))
                  ]),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width - 60,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    color: Color.fromRGBO(98, 166, 62, 1),
                    onPressed: () async {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          fullname, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in';
                        });
                      }
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
