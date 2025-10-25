class Endpoints {
  static const String baseUrl = 'http://192.168.29.127:8000/api/';

  static const String login = 'token/';
  static const String register = 'register/';
  static const String isUserExist = 'is_user_exist/';
  
  //users
  static const String userBase = 'users/';
  static const String allUsers = userBase + 'all/';
}
