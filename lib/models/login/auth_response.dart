// ignore_for_file: unnecessary_new, prefer_collection_literals, curly_braces_in_flow_control_structures

class AuthResponse {
  String? accessToken;
  int? expiresIn;
  int? refreshExpiresIn;
  String? refreshToken;
  String? tokenType;
  String? idToken;
  int? notBeforePolicy;
  String? sessionState;
  String? scope;

  AuthResponse(
      {this.accessToken,
      this.expiresIn,
      this.refreshExpiresIn,
      this.refreshToken,
      this.tokenType,
      this.idToken,
      this.notBeforePolicy,
      this.sessionState,
      this.scope});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    if (json["access_token"] is String) accessToken = json["access_token"];
    if (json["expires_in"] is int) expiresIn = json["expires_in"];
    if (json["refresh_expires_in"] is int)
      refreshExpiresIn = json["refresh_expires_in"];
    if (json["refresh_token"] is String)
      refreshToken = json["refresh_token"];
    if (json["token_type"] is String) tokenType = json["token_type"];
    if (json["id_token"] is String) idToken = json["id_token"];
    if (json["not-before-policy"] is int)
      notBeforePolicy = json["not-before-policy"];
    if (json["session_state"] is String)
      sessionState = json["session_state"];
    if (json["scope"] is String) scope = json["scope"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = accessToken;
    data["expires_in"] = expiresIn;
    data["refresh_expires_in"] = refreshExpiresIn;
    data["refresh_token"] = refreshToken;
    data["token_type"] = tokenType;
    data["id_token"] = idToken;
    data["not-before-policy"] = notBeforePolicy;
    data["session_state"] = sessionState;
    data["scope"] = scope;
    return data;
  }
}
