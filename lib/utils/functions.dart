import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:hive/hive.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/utils/constants.dart';

class Functions {
  static ConvertInJsonString(Map<String, dynamic> json) {
    return jsonEncode(json);
  }

  static HashPassword(String password) {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }
  static GetHiveUser() {
    final box = Hive.box('UserBox');
    final String json = box.get('data');
    final Map<String, dynamic> userMap = jsonDecode(json);
    return User.fromJson(userMap);
  }
  static GetActualMonth(){
    int intMonth = DateTime.now().month;
    return Constants.meses[intMonth - 1];
  
  }
}