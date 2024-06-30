import 'package:flutter_recipes/data/database.dart';

class SessionManager {
  //stuff for instances
  static SessionManager? _instance;
  static SessionManager get instance {
    _instance ??= SessionManager._internal();
    return _instance!;
  }

  SessionManager._internal();

  //session variables
  String? currentUsername;
  int? currentUserId;

  Future<void> setUser(String username) async {
    //get user from database and set it as session
    Map<String, dynamic>? user = await DatabaseHelper().getUserByUsername(username);
    if (user != null) {
      currentUsername = username;
      currentUserId = user['id'] as int;
    }
  }

  //clear session
  void clearUser() {
    currentUsername = null;
    currentUserId = null;
  }
  
  //logged in check
  bool get isLoggedIn => currentUsername != null;
}
