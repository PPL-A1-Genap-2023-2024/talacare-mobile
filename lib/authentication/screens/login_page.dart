import 'package:flutter/material.dart';
import 'package:talacare/helpers/utils.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  Color buttonColor = const Color.fromRGBO(254, 185, 0, 1);

  String statusMessage = "";
  bool passwordVisible=false; 

  // TextEditingControllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _loginFormKey,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Login to Talacare",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color.fromARGB(178, 3, 3, 3)),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        key: const ValueKey('emailField'),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email ",
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          else if (!Utils.isValidEmail(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(254)
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: !passwordVisible,
                        key: const ValueKey('passwordField'),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password ",
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          suffixIcon: IconButton( 
                            icon: Icon(passwordVisible 
                            ? Icons.visibility_off 
                            : Icons.visibility), 
                            color: buttonColor,
                            onPressed: () { 
                              setState( 
                                () { 
                                  passwordVisible = !passwordVisible; 
                                }, 
                              ); 
                            }, 
                          ), 
                          alignLabelWithHint: false,
                       ), 
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: ElevatedButton(
                          key: const ValueKey('loginButton'),
                          onPressed: () {
                            if (_loginFormKey.currentState!.validate()) {
                              String email = _emailController.text;
                              String password = _passwordController.text;

                              // Implement login logic later
                              print(email + " " + password);
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                            backgroundColor: MaterialStateProperty.all(buttonColor),
                          ),
                        ),
                      ),
                      Text(statusMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Don't have an account yet? Sign up",
                          style: TextStyle(color: buttonColor),
                          
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
