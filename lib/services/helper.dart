import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  final userLoggedInStatus = "USERLOGGEDINSTATUS";
  final userEmailKey = "USEREMAILKEY";
  final userNameKey = "USERNAMEKEY";
  final userUidKey = "USERUIDKEY";

  Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInStatus, isUserLoggedIn);
  }

  Future<bool> saveUserEmailKey(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, email);
  }

  Future<bool> saveUserNameKey(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, username);
  }

  Future<bool> saveUIDKey(String uid) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userUidKey, uid);
  }

  Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInStatus);
  }

  Future gettingUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  Future gettingUserUid() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userUidKey);
  }

  Future<String?> gettingUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
}
