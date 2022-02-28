

import 'package:sonnen_rennt/structs/route.dart';

enum RouteDetailResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, run: null
/// onSuccess: detail = null, run: Route Instance
class RouteDetailResult {

  RouteDetailResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RouteDetailResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RouteDetailResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RouteDetailResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RouteDetailResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RouteDetailResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RouteDetailResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RouteDetailResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RouteDetailResult.SUCCESS_200(DJKRoute route) {
    type = RouteDetailResultType.SUCCESS_200;
    this.route = route;
  }

  RouteDetailResultType type;
  String detail;

  DJKRoute route;
}

enum RouteCreateResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  BAD_REQUEST_400,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, id: null
/// onSuccess: detail = null, id: Route's id
class RouteCreateResult {

  RouteCreateResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RouteCreateResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RouteCreateResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RouteCreateResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RouteCreateResult.UNAUTHORIZED_400({ String detail = "Falsche Anfrage!" }) {
    type = RouteCreateResultType.BAD_REQUEST_400;
    this.detail = detail;
  }

  RouteCreateResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RouteCreateResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RouteCreateResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RouteCreateResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RouteCreateResult.SUCCESS_200(int route_id) {
    type = RouteCreateResultType.SUCCESS_200;
    this.id = route_id;
  }

  RouteCreateResultType type;
  String code;
  String detail;

  int id;
}

enum RouteEditResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  BAD_REQUEST_400,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, id: null
/// onSuccess: detail = null, id: Route's id
class RouteEditResult {

  RouteEditResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RouteEditResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RouteEditResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RouteEditResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RouteEditResult.UNAUTHORIZED_400({ String detail = "Falsche Anfrage!" }) {
    type = RouteEditResultType.BAD_REQUEST_400;
    this.detail = detail;
  }

  RouteEditResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RouteEditResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RouteEditResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RouteEditResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RouteEditResult.SUCCESS_200(int route_id) {
    type = RouteEditResultType.SUCCESS_200;
    this.id = route_id;
  }

  RouteEditResultType type;
  String code;
  String detail;

  int id;
}

enum RouteDeleteResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString
/// onSuccess: detail = null
class RouteDeleteResult {

  RouteDeleteResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RouteDeleteResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RouteDeleteResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RouteDeleteResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RouteDeleteResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RouteDeleteResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RouteDeleteResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RouteDeleteResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RouteDeleteResult.SUCCESS_200() {
    type = RouteDeleteResultType.SUCCESS_200;
  }

  RouteDeleteResultType type;
  String code;
  String detail;
}

enum RouteListResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  SUCCESS_200,
}

/// onError: detail = ErrorString, run: null
/// onSuccess: detail = null, route: List of Route(s)
class RouteListResult {

  RouteListResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RouteListResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RouteListResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RouteListResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RouteListResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RouteListResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RouteListResult.SUCCESS_200(List<DJKRoute> routes) {
    type = RouteListResultType.SUCCESS_200;
    this.routes = routes;
  }

  RouteListResultType type;
  String code;
  String detail;

  List<DJKRoute> routes;
}
