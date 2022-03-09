

import 'package:sonnen_rennt/structs/group.dart';
import 'package:sonnen_rennt/structs/route.dart';

enum GroupDetailResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, group: null
/// onSuccess: detail = null, group: Group Instance
class GroupDetailResult {

  GroupDetailResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = GroupDetailResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  GroupDetailResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = GroupDetailResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  GroupDetailResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = GroupDetailResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  GroupDetailResult.NOT_FOUND_404({ String detail = "Nicht gefunden!" }) {
    type = GroupDetailResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  GroupDetailResult.SUCCESS_200(Group group) {
    type = GroupDetailResultType.SUCCESS_200;
    this.group = group;
  }

  GroupDetailResultType? type;
  String? detail;

  Group? group;
}

enum GroupCreateResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  BAD_REQUEST_400,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, run: null
/// onSuccess: detail = null, id: Route's id
class GroupCreateResult {

  GroupCreateResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = GroupCreateResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  GroupCreateResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = GroupCreateResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  GroupCreateResult.UNAUTHORIZED_400({ String detail = "Falsche Anfrage!" }) {
    type = GroupCreateResultType.BAD_REQUEST_400;
    this.detail = detail;
  }

  GroupCreateResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = GroupCreateResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  GroupCreateResult.NOT_FOUND_404({ String? detail = "Nicht gefunden!" }) {
    type = GroupCreateResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  GroupCreateResult.SUCCESS_200(int groupId) {
    type = GroupCreateResultType.SUCCESS_200;
    this.id = groupId;
  }

  GroupCreateResultType? type;
  String? code;
  String? detail;

  int? id;
}

enum GroupEditResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  BAD_REQUEST_400,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString, id: null
/// onSuccess: detail = null, id: Groups's id
class GroupEditResult {

  GroupEditResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = GroupEditResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  GroupEditResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = GroupEditResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  GroupEditResult.UNAUTHORIZED_400({ String detail = "Falsche Anfrage!" }) {
    type = GroupEditResultType.BAD_REQUEST_400;
    this.detail = detail;
  }

  GroupEditResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = GroupEditResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  GroupEditResult.NOT_FOUND_404({ String? detail = "Nicht gefunden!" }) {
    type = GroupEditResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  GroupEditResult.SUCCESS_200(int groupIds) {
    type = GroupEditResultType.SUCCESS_200;
    this.id = groupIds;
  }

  GroupEditResultType? type;
  String? code;
  String? detail;

  int? id;
}

enum GroupDeleteResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  NOT_FOUND_404,
  SUCCESS_200,
}

/// onError: detail = ErrorString
/// onSuccess: detail = null
class GroupDeleteResult {

  GroupDeleteResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = GroupDeleteResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  GroupDeleteResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = GroupDeleteResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  GroupDeleteResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = GroupDeleteResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  GroupDeleteResult.NOT_FOUND_404({ String? detail = "Nicht gefunden!" }) {
    type = GroupDeleteResultType.NOT_FOUND_404;
    this.detail = detail;
  }

  GroupDeleteResult.SUCCESS_200() {
    type = GroupDeleteResultType.SUCCESS_200;
  }

  GroupDeleteResultType? type;
  String? code;
  String? detail;
}

enum GroupListResultType {
  UNKNOWN_ERROR,
  NETWORK_ERROR,
  UNAUTHORIZED_401,
  SUCCESS_200,
}

/// onError: detail = ErrorString, run: null
/// onSuccess: detail = null, route: List of Route(s)
class GroupListResult {

  GroupListResult.UNKNOWN_ERROR({ String detail = "Unbekannter Fehler!" }) {
    type = GroupListResultType.UNKNOWN_ERROR;
    this.detail = detail;
  }

  GroupListResult.NETWORK_ERROR({ String detail = "Netzwerkfehler!" }) {
    type = GroupListResultType.NETWORK_ERROR;
    this.detail = detail;
  }

  GroupListResult.UNAUTHORIZED_401({ String detail = "Keine Berechtigung!" }) {
    type = GroupListResultType.UNAUTHORIZED_401;
    this.detail = detail;
  }

  GroupListResult.SUCCESS_200(List<Group> groups) {
    type = GroupListResultType.SUCCESS_200;
    this.groups = groups;
  }

  GroupListResultType? type;
  String? code;
  String? detail;

  late List<Group> groups;
}
