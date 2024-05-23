import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsUtil {
  static FirebaseAnalytics _instance = FirebaseAnalytics.instance;

  static void setInstance(FirebaseAnalytics instance){
    _instance = instance;
  }

  static void logScreen(String pageName) async {
    print("*** LOGGING $pageName SCREEN ***");
    await _instance.logScreenView(screenClass: "Custom", screenName: pageName);
  }

  static void userTakeActivity() async {
    print("*** USER IS TAKING ACTIVITY ***");
    await _instance.logEvent(name: "user take_activity");
  }

  static void userGetActivityPoint() async {
    print("*** USER FINISHED TAKING ACTIVITY WITH SUCCESSFUL RESULT ***");
    await _instance.logEvent(name: "user_get_activity_point");
  }

  static void userTriggeredHospitalEvent() async {
    print("*** USER IS TAKEN TO THE HOSPITAL ***");
    await _instance.logEvent(name: "player_goes_to_hospital");
  }
}