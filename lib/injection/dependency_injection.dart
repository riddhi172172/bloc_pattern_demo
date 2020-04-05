import 'dart:async';
import 'dart:convert';

import 'package:pet/helper/prefkeys.dart';
import 'package:pet/model/sign_in.dart';
import 'package:pet/model/signup.dart';
import 'package:pet/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Injector {
  static SharedPreferences prefs;

  static String accessToken;

  static UserData userDataMain;
  static SignInResponse signInResponse;

  static StreamController<String> streamController;

  static getInstance() async {
    prefs = await SharedPreferences.getInstance();

    streamController = StreamController.broadcast();
    getUserData();
  }

  static updateAuthData(String token) async {
    await Injector.prefs.setString(PrefKeys.refreshToken, token);

    accessToken = token;
  }

  static updateUserData(UserData userData) async {
    await Injector.prefs
        .setString(PrefKeys.user, jsonEncode(userData.toJson()));

    userDataMain = userData;
//    if (userDataMain.auth != null) {
//      auth = userDataMain.auth;
//      accessToken = auth.accessToken;
//    }
  }

  static getUserData() {
    if (prefs.getString(PrefKeys.user) != null &&
        prefs.getString(PrefKeys.user).isNotEmpty) {
      userDataMain =
          UserData.fromJson(jsonDecode(prefs.getString(PrefKeys.user)));
//      if (userDataMain.auth != null) {
//        auth = userDataMain.auth;
//        accessToken = auth.accessToken;
//      }
    }
  }
}
