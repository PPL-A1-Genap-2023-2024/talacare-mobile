import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talacare/helpers/analytics_util.dart';
import 'package:talacare/helpers/audio_manager.dart';
import 'package:talacare/components/button.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AppLifecycleListener _listener;

  Future<UserCredential?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in the user with the credential
    UserCredential userCredential = await auth.signInWithCredential(credential);

    // Return the user credential
    return userCredential;
  }

  /* App Life Cycle Listener */
  @override
  void initState(){
    super.initState();

    AnalyticsUtil.logScreen("Login Screen");

    _listener = AppLifecycleListener(
      onPause: _onPause,
      onResume: _onResume,
    );
  }

  @override
  void dispose(){
    _listener.dispose();

    super.dispose();
  }

  void _onPause(){
    AudioManager.getInstance().pauseBackgroundMusic();
  }

  void _onResume(){
    AudioManager.getInstance().playBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.greenPrimary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => throw Exception(),
                child: const Text("Throw Test Exception"),
              ),
              Form(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Selamat Datang',
                          textAlign: TextAlign.center, style: AppTextStyles.h1),
                      const SizedBox(height: 10),
                      const Text('di Talacare',
                          textAlign: TextAlign.center, style: AppTextStyles.h2),
                      const SizedBox(height: 30),
                      Image.asset('assets/images/Illustrations/homepage.png'),
                      const SizedBox(height: 20),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: CustomButton(
                              text: "Masuk dengan Google",
                              size: ButtonSize.large,
                              assetImagePath:
                                  "assets/images/Illustrations/google.png",
                              onPressed: () {
                                signInWithGoogle();
                              })),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }));
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.textColor),
                                textStyle: MaterialStateProperty.all<TextStyle>(
                                    AppTextStyles.medium),
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
