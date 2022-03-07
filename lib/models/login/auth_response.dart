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
    if (json["access_token"] is String) this.accessToken = json["access_token"];
    if (json["expires_in"] is int) this.expiresIn = json["expires_in"];
    if (json["refresh_expires_in"] is int)
      this.refreshExpiresIn = json["refresh_expires_in"];
    if (json["refresh_token"] is String)
      this.refreshToken = json["refresh_token"];
    if (json["token_type"] is String) this.tokenType = json["token_type"];
    if (json["id_token"] is String) this.idToken = json["id_token"];
    if (json["not-before-policy"] is int)
      this.notBeforePolicy = json["not-before-policy"];
    if (json["session_state"] is String)
      this.sessionState = json["session_state"];
    if (json["scope"] is String) this.scope = json["scope"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["access_token"] = this.accessToken;
    data["expires_in"] = this.expiresIn;
    data["refresh_expires_in"] = this.refreshExpiresIn;
    data["refresh_token"] = this.refreshToken;
    data["token_type"] = this.tokenType;
    data["id_token"] = this.idToken;
    data["not-before-policy"] = this.notBeforePolicy;
    data["session_state"] = this.sessionState;
    data["scope"] = this.scope;
    return data;
  }
}
