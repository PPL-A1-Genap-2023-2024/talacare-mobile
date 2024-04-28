import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in the user with the credential
    await auth.signInWithCredential(credential);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("currentUser: ${FirebaseAuth.instance.currentUser?.email}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFBC9CCA),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Selamat Datang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFFFF6E6),
                              fontSize: 32,
                              fontFamily: 'Fredoka One',
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      const Text(
                        'di Talacare',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFD5EF9D),
                            fontSize: 24,
                            fontFamily: 'Fredoka One',
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 30),
                      Image.asset('assets/images/Illustrations/homepage.png'),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: IconButton(
                            icon: Image.asset(
                                'assets/images/Illustrations/Login Button.png'),
                            onPressed: () {
                              signInWithGoogle();
                            },
                          )),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }));
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 255, 246, 230)),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Fredoka',
                                  ),
                                ),
                              ),
                              child: Text('Masuk tanpa akun')))
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
