class _ApiUrls {
  static final String _prefix = "/api/v1";

  static final String _baseUrl =
      "https://spirtual-shakti-vi.onrender.com${_prefix}";

  //Auth
  static final String _login = "$_baseUrl/users/login"; //POST
  static final String _register = "$_baseUrl/users/login"; //POST
  static final String _verify = "$_baseUrl/users/verify"; //GET
  static final String _reVerify = "$_baseUrl/users/re-verify"; //GET
  static final String _forgotPassword =
      "$_baseUrl/users/forgot-password"; //POST
  static final String _resetPasword = "$_baseUrl/users/reset-password"; //POST
  static final String _updateProfileImage = "$_baseUrl/users/profile"; //POST
  static final String _updatePosterImage = "$_baseUrl/users/poster"; //POST
  static final String _logout = "$_baseUrl/users/logout"; //GET
  static final String _me = "$_baseUrl/users/me"; //GET
  static final String _deleteMe = "$_baseUrl/users"; //DELETE
  static final String _updatePassword = "$_baseUrl/users/password"; //PATCH

  //admin
  static final String _allUsers = "$_baseUrl/users/all"; //GET
  static final String _deleteUser = "$_baseUrl/users"; //DELETE
  static final String _getUser = "$_baseUrl/users"; //GET
  static final String _addRole = "$_baseUrl/users/add-role"; //PATCH

  //Auth getters
  String getLoginUrl() => _login;
  String getRegisterUrl() => _register;
  String getVerifyUrl({required String token}) => "$_verify?token=$token";
  String getReVerifyUrl({required String email}) => "$_reVerify?email=$email";
  String getForgotPasswordUrl() => _forgotPassword;
  String getResetPasswordUrl() => _resetPasword;
  String getUpdateProfileImageUrl({required String userId}) =>
      "$_updateProfileImage/$userId";
  String getUpdatePosterImageUrl({required String userId}) =>
      "$_updatePosterImage/$userId";
  String getLogoutUrl() => _logout;
  String getMeUrl() => _me;
  String getDeleteMeUrl() => _deleteMe;
  String getUpdatePasswordUrl() => _updatePassword;

  //Admin getters
  String getAllUsersUrl({int? pageNo, int? pageSize}) {
    String url = _allUsers;
    if (pageNo != null) url = "$url?pageNo=$pageNo";
    if (pageSize != null)
      url = pageNo != null
          ? "$url&pageSize=$pageSize"
          : "$url?pageSize=$pageSize";
    return url;
  }

  String getDeleteUserUrl({required String userId}) => "$_deleteUser/$userId";
  String getGetUserUrl({required String userId}) => "$_getUser/$userId";
  String getAddRoleUrl() => _addRole;

  //Aarti
}

final ApiUrls = _ApiUrls();
