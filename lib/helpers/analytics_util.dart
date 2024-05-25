import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsUtil {
  static FirebaseAnalytics _instance = FirebaseAnalytics.instance;

  static void setInstance(FirebaseAnalytics instance){
    _instance = instance;
  }

  static void logScreen(String pageName) async {
    await _instance.logScreenView(screenClass: "Custom", screenName: pageName);
  }

  static void userTakeActivity() async {
    await _instance.logEvent(name: "user take_activity");
  }

  static void userGetActivityPoint() async {
    await _instance.logEvent(name: "user_get_activity_point");
  }

  static void userTriggeredHospitalEvent() async {
    await _instance.logEvent(name: "player_goes_to_hospital");
  }
}