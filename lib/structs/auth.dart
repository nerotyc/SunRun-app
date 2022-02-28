
class AuthState {

  // static AuthState instance = AuthState.notLoggedIn();

  AuthState._({
    this.isWaiting,
    this.accessToken,
    this.userId,
    this.profileId,
  });

  bool isWaiting = true;

  String accessToken;
  int userId;
  int profileId;

  factory AuthState.waiting() {
    return AuthState._(
      isWaiting: true,
    );
  }

  factory AuthState.notLoggedIn() {
    return AuthState._(
      isWaiting: false,
    );
  }

  factory AuthState.loggedIn(accessToken, userId, profileId) {
    return AuthState._(
      isWaiting: false,
      accessToken: accessToken,
      userId: userId,
      profileId: profileId,
    );
  }

  bool get isLoggedIn {
    if(isWaiting) return false;
    return ((accessToken != null) && (accessToken.length > 0))
        && ((userId != null) && (userId > 0))
        && ((profileId != null) && (profileId > 0));
  }

}


enum LoginResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  FORM_ERROR,
  SUCCESS,
}

class LoginResult {

  LoginResult.UNKNOWN_ERROR({ String error = "Unbekannter Fehler!" }) {
    type = LoginResultType.UNKNOWN_ERROR;
    text = error;
  }

  LoginResult.NETWORK_ERROR({ String error = "Netzwerkfehler" }) {
    type = LoginResultType.NETWORK_ERROR;
    text = error;
  }

  LoginResult.FORM_ERROR({ String error = "Formularfehler!" }) {
    type = LoginResultType.FORM_ERROR;
    text = error;
  }

  LoginResult.SUCCESS(String accessToken) {
    type = LoginResultType.SUCCESS;
    this.accessToken = accessToken;
    text = "success";
  }

  LoginResultType type;
  String accessToken;

  String text;
  String usernameError = null;
  String passwordError = null;

}

enum UserIdResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  INVALID_TOKEN,
  SUCCESS,
}


class UserIdResult {

  UserIdResult.UNKNOWN_ERROR({ String error = "Unbekannter Fehler!" }) {
    type = UserIdResultType.UNKNOWN_ERROR;
    text = error;
  }

  UserIdResult.NETWORK_ERROR({ String error = "Netzwerkfehler" }) {
    type = UserIdResultType.NETWORK_ERROR;
    text = error;
  }

  UserIdResult.INVALID_TOKEN({ String error = "Authentifizierungsfehler" }) {
    type = UserIdResultType.INVALID_TOKEN;
    text = error;
  }

  UserIdResult.SUCCESS(int userId, int profileId) {
    type = UserIdResultType.SUCCESS;
    this.userId = userId;
    this.profileId = profileId;
    text = "success";
  }

  UserIdResultType type;
  int userId;
  int profileId;

  String text;

}

enum TestTokenResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  INVALID_TOKEN,
  SUCCESS,
}


class TestTokenResult {

  TestTokenResult.UNKNOWN_ERROR({ String error = "Unbekannter Fehler!" }) {
    type = TestTokenResultType.UNKNOWN_ERROR;
  }

  TestTokenResult.NETWORK_ERROR({ String error = "Netzwerkfehler" }) {
    type = TestTokenResultType.NETWORK_ERROR;
  }

  TestTokenResult.INVALID_TOKEN() {
    type = TestTokenResultType.INVALID_TOKEN;
  }

  TestTokenResult.SUCCESS() {
    type = TestTokenResultType.SUCCESS;
  }

  TestTokenResultType type;

}
