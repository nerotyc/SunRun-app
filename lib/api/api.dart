
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sonnen_rennt/api/const.dart';
import 'package:sonnen_rennt/api/group.dart';
import 'package:sonnen_rennt/api/route.dart';
import 'package:sonnen_rennt/api/run.dart';
import 'package:sonnen_rennt/logic/auth.dart';
import 'package:sonnen_rennt/structs/auth.dart';
import 'package:sonnen_rennt/structs/group.dart';
import 'package:sonnen_rennt/structs/route.dart';
import 'package:sonnen_rennt/structs/run.dart';

class AuthService {

  static Future<LoginResult> login(String? username, String? password) async {
    try {
      final response = await http.post(
        Uri.parse(api_url + 'auth/login/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'username': username,
          'password': password,
        }),
      ).timeout(Duration(seconds: 10));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("LOGIN: No response received!");
        return LoginResult.UNKNOWN_ERROR(error: "No response received!");
      }

      if (response.statusCode == 200) {
        // extract token
        String? accessToken = responseJson['token'];

        if(accessToken != null && accessToken.toString().length > 0) {
          print("login successful!");
          return LoginResult.SUCCESS(accessToken);
        } else {
          print("LOGIN: Unknown Exception: Cannot parse access_token");
          return LoginResult.UNKNOWN_ERROR(error: "Cannot parse access_token");
        }

      } else {
        print("Login failed with code " + response.statusCode.toString());

        String? usernameError = responseJson['username'];
        String? passwordError = responseJson['password'];

        LoginResult result = LoginResult.FORM_ERROR();

        if ((usernameError ?? "").length > 0) {
          result.usernameError = usernameError.toString();
        }
        if ((passwordError ?? "").length > 0) {
          result.passwordError = passwordError.toString();
        }

        if (result.usernameError == null && result.passwordError == null) {
          List? nonFieldErrors = responseJson['non_field_errors'];
          var errorDetail = responseJson['detail'];

          if((nonFieldErrors ?? []).length > 0) {
            if(nonFieldErrors![0] == "Unable to log in with provided credentials.") {
              result.passwordError = "Zugangsdaten inkorrekt!";
            } else {
              result.text = nonFieldErrors[0].toString();
            }
          } else {
            if (errorDetail != null && errorDetail.length > 0) {
              result.text = errorDetail.toString();
            } else {
              result.text = "Error: " + responseJson.toString();
            }
          }
        }

        return result;
      }

    } on TimeoutException {
      print("LOGIN: You are not connected to internet");
      return LoginResult.NETWORK_ERROR();
    } on SocketException {
      print("LOGIN: You are not connected to internet");
      return LoginResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("LOGIN: Unknown Exception (" + ex.runtimeType.toString() + "): " + ex.toString());
      return LoginResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("LOGIN: Unknown Error (" + err.runtimeType.toString() + "): " + err.toString());
      return LoginResult.UNKNOWN_ERROR();
    }
  }

  static Future<UserIdResult> fetchUserId({String? accessToken}) async {
    String? token = accessToken;
    if(token == null) token = authHandler.accessToken;
    if(token == null) throw Error();

    try {
      final response = await http.get(
        Uri.parse(api_url + 'user/user-id/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 10));
      // TODO timeout

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("Fetching user_id: No response received!");
        return UserIdResult.UNKNOWN_ERROR(error: "No response received!");
      }

      if (response.statusCode == 200) {
        // extract token
        int? userId = responseJson['user_id'];
        int? profileId = responseJson['profile_id'];

        if (userId != null && profileId != null) {
          print("Fetching user_id successful!");
          return UserIdResult.SUCCESS(userId, profileId);
        } else {
          print("Fetching user_id: Unknown Exception: Cannot parse user_id or profile_id");
          return UserIdResult.UNKNOWN_ERROR(
              error: "Cannot parse user_id or profile_id");
        }
      } else if(response.statusCode == 401) {
        print("Fetching user_id failed with code " + response.statusCode.toString());
        UserIdResult result = UserIdResult.INVALID_TOKEN();
        authHandler.checkTokenValidity();
        return result;
      } else {
        print("Fetching user_id with code " + response.statusCode.toString());
        UserIdResult result = UserIdResult.UNKNOWN_ERROR();
        return result;
      }

    } on TimeoutException {
      print("Fetching user_id: You are not connected to internet");
      return UserIdResult.NETWORK_ERROR();
    } on SocketException {
      print("Fetching user_id: You are not connected to internet");
      return UserIdResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("Fetching user_id: Unknown Exception: " + ex.toString());
      return UserIdResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("Fetching user_id: Unknown Error: " + err.toString());
      return UserIdResult.UNKNOWN_ERROR();
    }
  }

  static Future<TestTokenResult> testToken() async {
    String? token = authHandler.accessToken;
    if(token == null) throw Error();

    try {
      final response = await http.get(
        Uri.parse(api_url + 'user/user-id/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 10));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("Fetching user_id: No response received!");
        return TestTokenResult.UNKNOWN_ERROR(error: "No response received!");
      }

      if (response.statusCode == 200) {
        return TestTokenResult.SUCCESS();
      } else if(response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return TestTokenResult.INVALID_TOKEN();
      } else {
        return TestTokenResult.UNKNOWN_ERROR();
      }

    } on TimeoutException {
      print("TestTokenResult: You are not connected to internet");
      return TestTokenResult.NETWORK_ERROR();
    } on SocketException {
      print("TestTokenResult: You are not connected to internet");
      return TestTokenResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("TestTokenResult: Unknown Exception: " + ex.toString());
      return TestTokenResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("TestTokenResult: Unknown Error: " + err.toString());
      return TestTokenResult.UNKNOWN_ERROR();
    }
  }

}

class RunApi {

  static Future<RunDetailResult> runDetail(int? runId) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'run/' + runId.toString() + '/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 20));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("Fetch Run Detail: No response received!");
        return RunDetailResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        Run run = Run.fromJson(responseJson);

        if(run == null) return RunDetailResult.UNKNOWN_ERROR(
            detail: "Error parsing response!"
        );
        return RunDetailResult.SUCCESS_200(run);

      } else if (response.statusCode == 401){
        authHandler.checkTokenValidity();
        return RunDetailResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404){
        return RunDetailResult.NOT_FOUND_404();
      } else {
        print("RunDetailResult: " + response.statusCode.toString());
        return RunDetailResult.UNKNOWN_ERROR();
      }

    } on TimeoutException {
      print("RunDetailResult: You are not connected to internet");
      return RunDetailResult.NETWORK_ERROR();
    } on SocketException {
      print("RunDetailResult: You are not connected to internet");
      return RunDetailResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RunDetailResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RunDetailResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RunDetailResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RunDetailResult.UNKNOWN_ERROR();
    }
  }

  static Future<RunCreateResult> runCreate(Run run) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.post(
        Uri.parse(api_url + 'run/create/'),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: run.toMap(),
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RunCreateResult: No response received!");
        return RunCreateResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 201) {
        var respId = responseJson['id'];
        if(respId == null) return RunCreateResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return RunCreateResult.SUCCESS_200(respId);
      } else if (response.statusCode == 400) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RunCreateResult.NOT_FOUND_404(detail: respDetail);
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RunCreateResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RunCreateResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return RunCreateResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RunCreateResult: You are not connected to internet");
      return RunCreateResult.NETWORK_ERROR();
    } on SocketException {
      print("RunCreateResult: You are not connected to internet");
      return RunCreateResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RunCreateResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RunCreateResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RunCreateResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RunCreateResult.UNKNOWN_ERROR();
    }
  }

  static Future<RunEditResult> runEdit(Run run) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.put(
        Uri.parse(api_url + 'run/edit/'
            + run.id.toString() + '/'),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: run.toMap(),
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RunEditResult: No response received!");
        return RunEditResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        var respId = responseJson['id'];
        if(respId == null) return RunEditResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return RunEditResult.SUCCESS_200(respId);
      } else if (response.statusCode == 400) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RunEditResult.NOT_FOUND_404(detail: respDetail);
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RunEditResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RunEditResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return RunEditResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RunEditResult: You are not connected to internet");
      return RunEditResult.NETWORK_ERROR();
    } on SocketException {
      print("RunEditResult: You are not connected to internet");
      return RunEditResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RunEditResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RunEditResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RunEditResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RunEditResult.UNKNOWN_ERROR();
    }
  }

  static Future<RunDeleteResult> runDelete(int? runId) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.delete(
        Uri.parse(api_url + 'run/delete/'
            + runId.toString() + '/'),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RunDeleteResult: No response received!");
        return RunDeleteResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        var respCode = int.parse(responseJson['code']);
        if(respCode != 200) return RunDeleteResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return RunDeleteResult.SUCCESS_200();
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RunDeleteResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RunDeleteResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return RunDeleteResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RunDeleteResult: You are not connected to internet");
      return RunDeleteResult.NETWORK_ERROR();
    } on SocketException {
      print("RunDeleteResult: You are not connected to internet");
      return RunDeleteResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RunDeleteResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RunDeleteResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RunDeleteResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RunDeleteResult.UNKNOWN_ERROR();
    }
  }

  static Future<RunListUserResult> runListUser() async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'run/user/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RunListUserResult: No response received!");
        return RunListUserResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        try {
          List<Run> runs = [];
          for (var run in responseJson) {
            var _obj = Run.fromJson(run);
            if (_obj != null) runs.add(_obj);
          }
          return RunListUserResult.SUCCESS_200(runs);
        } on Error catch(err) {
          return RunListUserResult.UNKNOWN_ERROR();
        } on Exception catch(exc) {
          return RunListUserResult.UNKNOWN_ERROR();
        }
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RunListUserResult.UNAUTHORIZED_401();
      }
      else {
        return RunListUserResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RunListUserResult: You are not connected to internet");
      return RunListUserResult.NETWORK_ERROR();
    } on SocketException {
      print("RunListUserResult: You are not connected to internet");
      return RunListUserResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RunListUserResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RunListUserResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RunListUserResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RunListUserResult.UNKNOWN_ERROR();
    }
  }

}

class RouteApi {

  static Future<RouteDetailResult> routeDetail(int routeId) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'route/' + routeId.toString() + '/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 20));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("Fetch Run Detail: No response received!");
        return RouteDetailResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        DJKRoute route = DJKRoute.fromJson(responseJson);

        if(route == null) return RouteDetailResult.UNKNOWN_ERROR(
            detail: "Error parsing response!"
        );
        return RouteDetailResult.SUCCESS_200(route);

      } else if (response.statusCode == 401){
        authHandler.checkTokenValidity();
        return RouteDetailResult.UNAUTHORIZED_401();

      } else if (response.statusCode == 404){
        return RouteDetailResult.NOT_FOUND_404();

      } else {
        print("RunDetailResult: " + response.statusCode.toString());
        return RouteDetailResult.UNKNOWN_ERROR();
      }

    } on TimeoutException {
      print("RouteDetailResult: You are not connected to internet");
      return RouteDetailResult.NETWORK_ERROR();
    } on SocketException {
      print("RouteDetailResult: You are not connected to internet");
      return RouteDetailResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RouteDetailResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RouteDetailResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RouteDetailResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RouteDetailResult.UNKNOWN_ERROR();
    }
  }

  static Future<RouteCreateResult> routeCreate(DJKRoute route) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.post(
        Uri.parse(api_url + 'route/create/'),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: route.toMap(),
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RunCreateResult: No response received!");
        return RouteCreateResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 201) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respId = responseJson['id'];
        if(respId == null) return RouteCreateResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return RouteCreateResult.SUCCESS_200(respId);
      } else if (response.statusCode == 400) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RouteCreateResult.NOT_FOUND_404(detail: respDetail);
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RouteCreateResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RouteCreateResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return RouteCreateResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RouteCreateResult: You are not connected to internet");
      return RouteCreateResult.NETWORK_ERROR();
    } on SocketException {
      print("RouteCreateResult: You are not connected to internet");
      return RouteCreateResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RouteCreateResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RouteCreateResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RouteCreateResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RouteCreateResult.UNKNOWN_ERROR();
    }
  }

  static Future<RouteEditResult> routeEdit(DJKRoute route) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.put(
        Uri.parse(api_url + 'route/edit/'
            + route.id.toString() + '/'),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: route.toMap(),
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RouteEditResult: No response received!");
        return RouteEditResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respId = responseJson['id'];
        if(respId == null) return RouteEditResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return RouteEditResult.SUCCESS_200(respId);
      } else if (response.statusCode == 400) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RouteEditResult.NOT_FOUND_404(detail: respDetail);
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RouteEditResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RouteEditResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return RouteEditResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RouteEditResult: You are not connected to internet");
      return RouteEditResult.NETWORK_ERROR();
    } on SocketException {
      print("RouteEditResult: You are not connected to internet");
      return RouteEditResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RouteEditResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RouteEditResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RouteEditResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RouteEditResult.UNKNOWN_ERROR();
    }
  }

  static Future<RouteDeleteResult> routeDelete(int runId) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.delete(
        Uri.parse(api_url + 'route/delete/'
            + runId.toString() + '/'),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RunDeleteResult: No response received!");
        return RouteDeleteResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        var respCode = int.parse(responseJson['code']);
        if(respCode != 200) return RouteDeleteResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return RouteDeleteResult.SUCCESS_200();
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RouteDeleteResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return RouteDeleteResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return RouteDeleteResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RouteDeleteResult: You are not connected to internet");
      return RouteDeleteResult.NETWORK_ERROR();
    } on SocketException {
      print("RouteDeleteResult: You are not connected to internet");
      return RouteDeleteResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RouteDeleteResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RouteDeleteResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RouteDeleteResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RouteDeleteResult.UNKNOWN_ERROR();
    }
  }

  static Future<RouteListResult> routeListUser() async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'route/user/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RouteListResult: No response received!");
        return RouteListResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        try {
          List<DJKRoute> routes = [];
          for (var route in responseJson) {
            var _obj = DJKRoute.fromJson(route);
            if (_obj != null) routes.add(_obj);
          }
          return RouteListResult.SUCCESS_200(routes);
        } on Error catch(err) {
          return RouteListResult.UNKNOWN_ERROR();
        } on Exception catch(exc) {
          return RouteListResult.UNKNOWN_ERROR();
        }
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RouteListResult.UNAUTHORIZED_401();
      }
      else {
        return RouteListResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RouteListResult: You are not connected to internet");
      return RouteListResult.NETWORK_ERROR();
    } on SocketException {
      print("RouteListResult: You are not connected to internet");
      return RouteListResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RouteListResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RouteListResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RouteListResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RouteListResult.UNKNOWN_ERROR();
    }
  }

  static Future<RouteListResult> routeList() async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'route/list/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RouteListResult: No response received!");
        return RouteListResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        try {
          List<DJKRoute> routes = [];
          for (var route in responseJson) {
            var _obj = DJKRoute.fromJson(route);
            if (_obj != null) routes.add(_obj);
          }
          return RouteListResult.SUCCESS_200(routes);
        } on Error catch(err) {
          return RouteListResult.UNKNOWN_ERROR();
        } on Exception catch(exc) {
          return RouteListResult.UNKNOWN_ERROR();
        }
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return RouteListResult.UNAUTHORIZED_401();
      }
      else {
        return RouteListResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("RouteListResult: You are not connected to internet");
      return RouteListResult.NETWORK_ERROR();
    } on SocketException {
      print("RouteListResult: You are not connected to internet");
      return RouteListResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("RouteListResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return RouteListResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("RouteListResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return RouteListResult.UNKNOWN_ERROR();
    }
  }

}

class GroupApi {

  static Future<GroupDetailResult> groupDetail(int groupId) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'group/' +  groupId.toString() + '/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 20));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("Fetch Run Detail: No response received!");
        return GroupDetailResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        Group group = Group.fromJson(responseJson);

        if(group == null) return GroupDetailResult.UNKNOWN_ERROR(
            detail: "Error parsing response!"
        );
        return GroupDetailResult.SUCCESS_200(group);

      } else if (response.statusCode == 401){
        authHandler.checkTokenValidity();
        return GroupDetailResult.UNAUTHORIZED_401();

      } else if (response.statusCode == 404){
        return GroupDetailResult.NOT_FOUND_404();

      } else {
        print("GroupDetailResult: " + response.statusCode.toString());
        return GroupDetailResult.UNKNOWN_ERROR();
      }

    } on TimeoutException {
      print("GroupDetailResult: You are not connected to internet");
      return GroupDetailResult.NETWORK_ERROR();
    } on SocketException {
      print("GroupDetailResult: You are not connected to internet");
      return GroupDetailResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("GroupDetailResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return GroupDetailResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("GroupDetailResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return GroupDetailResult.UNKNOWN_ERROR();
    }
  }

  static Future<GroupCreateResult> groupCreate(Group group) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.post(
        Uri.parse(api_url + 'route/create/'),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: group.toMap(),
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("GroupCreateResult: No response received!");
        return GroupCreateResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 201) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respId = responseJson['id'];
        if(respId == null) return GroupCreateResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return GroupCreateResult.SUCCESS_200(respId);
      } else if (response.statusCode == 400) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return GroupCreateResult.NOT_FOUND_404(detail: respDetail);
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return GroupCreateResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return GroupCreateResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return GroupCreateResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("GroupCreateResult: You are not connected to internet");
      return GroupCreateResult.NETWORK_ERROR();
    } on SocketException {
      print("GroupCreateResult: You are not connected to internet");
      return GroupCreateResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("GroupCreateResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return GroupCreateResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("GroupCreateResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return GroupCreateResult.UNKNOWN_ERROR();
    }
  }

  static Future<GroupEditResult> groupEdit(Group group) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.put(
        Uri.parse(api_url + 'group/edit/'
            + group.id.toString() + '/'),
        encoding: Encoding.getByName("utf-8"),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
        body: group.toMap(),
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RouteEditResult: No response received!");
        return GroupEditResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respId = responseJson['id'];
        if(respId == null) return GroupEditResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return GroupEditResult.SUCCESS_200(respId);
      } else if (response.statusCode == 400) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return GroupEditResult.NOT_FOUND_404(detail: respDetail);
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return GroupEditResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return GroupEditResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return GroupEditResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("GroupEditResult: You are not connected to internet");
      return GroupEditResult.NETWORK_ERROR();
    } on SocketException {
      print("GroupEditResult: You are not connected to internet");
      return GroupEditResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("GroupEditResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return GroupEditResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("GroupEditResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return GroupEditResult.UNKNOWN_ERROR();
    }
  }

  static Future<GroupDeleteResult> groupDelete(int groupId) async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.delete(
        Uri.parse(api_url + 'group/delete/'
            + groupId.toString() + '/'),
        headers: {
          // 'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 40));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("GroupDeleteResult: No response received!");
        return GroupDeleteResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        var respCode = int.parse(responseJson['code']);
        if(respCode != 200) return GroupDeleteResult.UNKNOWN_ERROR(
            detail: "Response id could not be parsed"
        );
        return GroupDeleteResult.SUCCESS_200();
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return GroupDeleteResult.UNAUTHORIZED_401();
      } else if (response.statusCode == 404) {
        var respCode = responseJson['code'];
        var respStatus = responseJson['status'];
        var respDetail = responseJson['detail'];
        return GroupDeleteResult.NOT_FOUND_404(detail: respDetail);
      }
      else {
        return GroupDeleteResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("GroupDeleteResult: You are not connected to internet");
      return GroupDeleteResult.NETWORK_ERROR();
    } on SocketException {
      print("GroupDeleteResult: You are not connected to internet");
      return GroupDeleteResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("GroupDeleteResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return GroupDeleteResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("GroupDeleteResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return GroupDeleteResult.UNKNOWN_ERROR();
    }
  }

  static Future<GroupListResult> groupListUser() async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'group/user/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("RouteListResult: No response received!");
        return GroupListResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        try {
          List<Group> groups = [];
          for (var group in responseJson) {
            var _obj = Group.fromJson(group);
            if (_obj != null) groups.add(_obj);
          }
          return GroupListResult.SUCCESS_200(groups);
        } on Error catch(err) {
          return GroupListResult.UNKNOWN_ERROR();
        } on Exception catch(exc) {
          return GroupListResult.UNKNOWN_ERROR();
        }
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return GroupListResult.UNAUTHORIZED_401();
      }
      else {
        return GroupListResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("GroupListResult: You are not connected to internet");
      return GroupListResult.NETWORK_ERROR();
    } on SocketException {
      print("v: You are not connected to internet");
      return GroupListResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("GroupListResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return GroupListResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("GroupListResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return GroupListResult.UNKNOWN_ERROR();
    }
  }

  static Future<GroupListResult> groupList() async {
    String token = authHandler.accessToken!;

    try {
      final response = await http.get(
        Uri.parse(api_url + 'group/list/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token " + token,
        },
      ).timeout(Duration(seconds: 60));

      final responseJson = jsonDecode(response.body);
      if(responseJson == null) {
        print("GroupListResult: No response received!");
        return GroupListResult.UNKNOWN_ERROR(detail: "No response received!");
      }

      if (response.statusCode == 200) {
        try {
          List<Group> groups = [];
          for (var group in responseJson) {
            var _obj = Group.fromJson(group);
            if (_obj != null) groups.add(_obj);
          }
          return GroupListResult.SUCCESS_200(groups);
        } on Error catch(err) {
          return GroupListResult.UNKNOWN_ERROR();
        } on Exception catch(exc) {
          return GroupListResult.UNKNOWN_ERROR();
        }
      } else if (response.statusCode == 401) {
        authHandler.checkTokenValidity();
        return GroupListResult.UNAUTHORIZED_401();
      }
      else {
        return GroupListResult.UNKNOWN_ERROR();
      }
    } on TimeoutException {
      print("GroupListResult: You are not connected to internet");
      return GroupListResult.NETWORK_ERROR();
    } on SocketException {
      print("GroupListResult: You are not connected to internet");
      return GroupListResult.NETWORK_ERROR();
    } on Exception catch(ex) {
      print("GroupListResult: Unknown Exception ("
          + ex.runtimeType.toString() + "): " + ex.toString());
      return GroupListResult.UNKNOWN_ERROR();
    } on Error catch(err) {
      print("GroupListResult: Unknown Error ("
          + err.runtimeType.toString() + "): " + err.toString());
      return GroupListResult.UNKNOWN_ERROR();
    }
  }

}