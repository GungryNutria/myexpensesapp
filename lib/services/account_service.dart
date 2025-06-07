
import 'dart:convert';

import 'package:myexpensesapp/models/account.dart';
import 'package:myexpensesapp/models/account_create.dart';
import 'package:myexpensesapp/models/error_details.dart';
import 'package:myexpensesapp/models/type_account.dart';
import 'package:myexpensesapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class AccountService {
  Future<List<Account>> getAccounts(int id) async {
    try{
      final url = Uri.parse('${Constants.API_URL}/accounts/$id');
      final response = await http.get(url);
      if(response.statusCode == 200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Account.fromJson(json)).toList();
      }else{
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
      
    }catch(e){
      throw Exception('Error Catch: $e');
    }
  }

  Future<dynamic> getTypeAccounts() async {
    try{
      final url = Uri.parse('${Constants.API_URL}/type-accounts');
      final response = await http.get(url);
      if(response.statusCode == 200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => TypeAccount.fromJson(json)).toList();
      }
      return Errordetails.fromJson(jsonDecode(response.body));
    }catch(e){
      return Errordetails(error: 'Error Catch', message: e.toString(), statusCode: 0);
    }
  }

  Future<bool> addAccount(AccountCreate account) async {
    try{
      final url = Uri.parse('${Constants.API_URL}/accounts');
      var json = jsonEncode(account.toJson());
      
      final response = await http.post(url, body: json, headers: Constants.HEADERS); 
      if(response.statusCode == 200 || response.statusCode == 201) return true;
      return false;
    }catch(e){
      return false;
    }
  }
}