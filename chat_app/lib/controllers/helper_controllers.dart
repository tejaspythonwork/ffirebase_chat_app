import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperController extends GetxController {
  static const String _userLoggedKey = 'USERLOGGEDINKEY';
  static const String _emailKey = 'USEREMAILKEY';
  static const String _nameKey = 'USERNAMEKEY';

  var isUserLoggedIn = false.obs;
  var userEmail = ''.obs;
  var userName = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // loadUserLoggedInStatus();
  // loadUserEmail();
  // loadUserName();
  // }

  Future<void> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    bool result = await spref.setBool(_userLoggedKey, isUserLoggedIn);
    if (result) {
      this.isUserLoggedIn.value = isUserLoggedIn;
    }
  }

  Future<void> saveUserEmail(String email) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    bool result = await spref.setString(_emailKey, email);
    if (result) {
      userEmail.value = email;
    }
  }

  Future<void> saveUserName(String name) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    bool result = await spref.setString(_nameKey, name);
    if (result) {
      userName.value = name;
    }
  }

  Future loadUserLoggedInStatus() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    isUserLoggedIn.value = spref.getBool(_userLoggedKey) ?? false;
    return isUserLoggedIn.value;
  }

  Future loadUserEmail() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    userEmail.value = spref.getString(_emailKey) ?? '';
    return userEmail.value;
  }

  Future<String> loadUserName() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    userName.value = spref.getString(_nameKey) ?? '';
    return userName.value;
  }
}
