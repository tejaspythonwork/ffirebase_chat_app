import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userLoggedKey = 'USERLOGGEDINKEY';
  static String emailKey = 'USEREMAILKEY';
  static String nameKey = 'USERNAMEKEY';

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return await spref.setBool(userLoggedKey, isUserLoggedIn);
  }

  static Future saveUserEmail(String email) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return await spref.setString(emailKey, email);
  }

  static Future saveUserName(String name) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return await spref.setString(nameKey, name);
  }

  static Future getLoggedInStatus() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return spref.getBool(userLoggedKey);
  }

  static Future getUserName() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return spref.getString(nameKey);
  }

  static Future getUserEmail() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return spref.getString(emailKey);
  }
}
