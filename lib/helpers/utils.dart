class Utils {
  static bool isValidEmail(String value) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isValidPassword(String value) {
    return value.length >= 8;
  }
}