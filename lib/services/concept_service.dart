
import 'dart:convert';
import 'package:myexpensesapp/models/category.dart';
import 'package:myexpensesapp/models/concept.dart';
import 'package:myexpensesapp/models/concept_create.dart';
import 'package:myexpensesapp/models/error_details.dart';
import 'package:myexpensesapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConceptService {

  // Simulate a network call to fetch concepts
  Future<List<Concept>> getConcepts(int id) async {
    try {
      final url = Uri.parse('${Constants.API_URL}/concepts/$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Concept.fromJson(json)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Error fetching concepts: $e');
    }
  }

  Future<dynamic> getCategories() async {
    try {
      final url = Uri.parse('${Constants.API_URL}/categories');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Category.fromJson(json)).toList();
      } else {
        return Errordetails.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return Errordetails(error: 'Error Catch', message: e.toString(), statusCode: 0);
    }
  }

  // Simulate a network call to create a concept
  Future<dynamic> addConcept(ConceptCreate concept) async {
    try {
      final url = Uri.parse('${Constants.API_URL}/concepts');
      var json = jsonEncode(concept.toJson());
      final response = await http.post(url, body: json, headers: Constants.HEADERS);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Concept.fromJson(jsonDecode(response.body));
      } else {
        return Errordetails(error: 'Concept Not Saved', 
                            message: "Failed Saving Concept", 
                            statusCode: response.statusCode);
      }
    } catch (e) {
      return Errordetails(error: 'Error Catch', message: e.toString(), statusCode: 0);
    }
  }

  Future<dynamic> deleteConcept(int conceptId) async {
    try {
      final url = Uri.parse('${Constants.API_URL}/concepts/$conceptId');
      final response = await http.delete(url, headers: Constants.HEADERS);
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;;
      } else {
        return Errordetails.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return Errordetails(error: 'Error Catch', message: e.toString(), statusCode: 0);
    }
  }
}