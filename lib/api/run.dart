

import 'package:sonnen_rennt/structs/run.dart';

enum RunDetailResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, run: null
/// onSuccess: detail = null, run: Run Instance
class RunDetailResult {

  RunDetailResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RunDetailResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RunDetailResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RunDetailResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RunDetailResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RunDetailResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RunDetailResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RunDetailResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RunDetailResult.SUCCESS_200(Run run) {
    type = RunDetailResultType.SUCCESS_200;
    this.run = run;
  }

  RunDetailResultType type;
  String detail;

  Run run;
}

enum RunCreateResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  BAD_REQUEST_400,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, id: null
/// onSuccess: detail = null, id: Run's id
class RunCreateResult {

  RunCreateResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RunCreateResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RunCreateResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RunCreateResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RunCreateResult.BAD_REQUEST_400({ String detail = "Falsche Anfrage!" }) {
    type = RunCreateResultType.BAD_REQUEST_400;
    this.detail = detail;
  }

  RunCreateResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RunCreateResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RunCreateResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RunCreateResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RunCreateResult.SUCCESS_200(int run_id) {
    type = RunCreateResultType.SUCCESS_200;
    this.id = run_id;
  }

  RunCreateResultType type;
  String code;
  String detail;

  int id;
}

enum RunEditResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  BAD_REQUEST_400,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, id: null
/// onSuccess: detail = null, id: Run's id
class RunEditResult {

  RunEditResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RunEditResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RunEditResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RunEditResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RunEditResult.UNAUTHORIZED_400({ String detail = "Falsche Anfrage!" }) {
    type = RunEditResultType.BAD_REQUEST_400;
    this.detail = detail;
  }

  RunEditResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RunEditResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RunEditResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RunEditResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RunEditResult.SUCCESS_200(int run_id) {
    type = RunEditResultType.SUCCESS_200;
    this.id = run_id;
  }

  RunEditResultType type;
  String code;
  String detail;

  int id;
}

enum RunDeleteResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString
/// onSuccess: detail = null
class RunDeleteResult {

  RunDeleteResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RunDeleteResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RunDeleteResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RunDeleteResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RunDeleteResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RunDeleteResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RunDeleteResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = RunDeleteResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  RunDeleteResult.SUCCESS_200() {
    type = RunDeleteResultType.SUCCESS_200;
  }

  RunDeleteResultType type;
  String code;
  String detail;
}

enum RunListUserResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  SUCCESS_200,
}

/// onError: detail = ErrorString, runs: null
/// onSuccess: detail = null, runs: List of Run(s)
class RunListUserResult {

  RunListUserResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = RunListUserResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  RunListUserResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = RunListUserResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  RunListUserResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = RunListUserResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  RunListUserResult.SUCCESS_200(List<Run> runs) {
    type = RunListUserResultType.SUCCESS_200;
    this.runs = runs;
  }

  RunListUserResultType type;
  String code;
  String detail;

  List<Run> runs;
}
