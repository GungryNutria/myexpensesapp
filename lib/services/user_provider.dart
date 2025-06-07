import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myexpensesapp/models/error_details.dart';
import 'package:myexpensesapp/models/login_model.dart';
import 'package:myexpensesapp/models/user.dart';
import 'package:myexpensesapp/utils/constants.dart';
import 'package:myexpensesapp/utils/functions.dart';

class UserProvider{
  Future<dynamic> registerUser(User user) async{
    try{
      
      final url = Uri.parse('${Constants.API_URL}/user');
      final response = await http.post(
        url,
        headers: Constants.HEADERS, 
        body: jsonEncode(user));
      if(response.statusCode == 200 || response.statusCode == 201) return User.fromJson(jsonDecode(response.body));
      return Errordetails.fromJson(jsonDecode(response.body));
    }catch(e){
      return Errordetails(error: 'Error Catch', message: e.toString(), statusCode: 0);
    }
      
  }

  Future<dynamic> loginUser(LoginModel login) async {
    try{
      final url = Uri.parse('${Constants.API_URL}/user/login');
      final response = await http.post(
        url,
        headers: Constants.HEADERS,
        body: jsonEncode(login));
        if(response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) return User.fromJson(jsonDecode(response.body));
      return Errordetails.fromJson(jsonDecode(response.body));
    }catch(e){
      print('Error: $e');
      return Errordetails(error: 'Error Catch',message: e.toString(), statusCode: 0);
    }
  }
}