class Endpoints {
  static const String baseUrl = 'http://10.68.232.6:8000/api/';

  static const String login = 'token/';
  static const String register = 'register/';
  static const String isUserExist = 'is_user_exist/';

  static const String userBase = 'users/';
  static const String allUsers = userBase + 'all/';
  static const String createInfo = userBase + 'create-info/';
}
