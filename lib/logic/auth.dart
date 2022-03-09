
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/structs/auth.dart';

AuthHandler authHandler = AuthHandler._();

class AuthHandler extends ChangeNotifier {

  AuthState _currentState = AuthState.waiting();

  AuthHandler._();

  Future<bool> tryReadSecretsAndLogin() async {
    var secStorage = FlutterSecureStorage();
    var accessToken = await secStorage.read(key: "access_token");
    var userId = await secStorage.read(key: "user_id");
    var profileId = await secStorage.read(key: "profile_id");

    if((accessToken != null) && (userId != null) && (profileId != null)) {
      _currentState = AuthState.loggedIn(
          accessToken,
          int.parse(userId),
          int.parse(profileId)
      );
      notifyListeners();
      return true;
    } else {
      logout();
      notifyListeners();
      return false;
    }
  }

  Future<void> checkTokenValidity() async {
    if(_currentState.isLoggedIn) {
      TestTokenResult res = await AuthService.testToken();

      if (res.type == TestTokenResultType.INVALID_TOKEN) {
        logout();
      } else if (res.type == TestTokenResultType.SUCCESS) {
        return;
      } else {
        return;
      }
    }
  }

  /// true: success
  /// LoginResult: failure
  /// UserIdResult: failure
  Future<dynamic> tryLoginAndStore(String? username, String? password) async {
    LoginResult result = await AuthService.login(username, password);
    if(result.type == LoginResultType.SUCCESS) {

      UserIdResult userIdResult =
        await AuthService.fetchUserId(accessToken: result.accessToken);
      if(userIdResult.type == UserIdResultType.SUCCESS) {
        var secStorage = FlutterSecureStorage();
        secStorage.write(key: "access_token", value: result.accessToken);
        secStorage.write(key: "user_id", value: userIdResult.userId.toString());
        secStorage.write(key: "profile_id", value: userIdResult.profileId.toString());
        _currentState = AuthState.loggedIn(
            result.accessToken,
            userIdResult.userId,
            userIdResult.profileId
        );
        notifyListeners();
        return true;
      }
      return userIdResult;
    }
    return result;
  }

  Future<String?> logout() async {
    var secStorage = FlutterSecureStorage();
    secStorage.delete(key: "access_token");
    secStorage.delete(key: "user_id");
    secStorage.delete(key: "profile_id");
    _currentState = AuthState.notLoggedIn();
    notifyListeners();
  }

  bool? get isWaiting {
    return _currentState.isWaiting;
  }

  bool get isLoggedIn {
    return _currentState.isLoggedIn;
  }

  String? get accessToken {
    return _currentState.accessToken;
  }

  int? get userId {
    return _currentState.userId;
  }

  int? get profileId {
    return _currentState.profileId;
  }

}