
import 'dart:convert';

import 'package:myexpensesapp/models/concept.dart';
import 'package:myexpensesapp/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConceptService {

  // Simulate a network call to fetch concepts
  Future<List<Concept>> getConcepts(int id) async {
    try {
      print('Fetching concepts for account ID: $id');
      final url = Uri.parse('${Constants.API_URL}/concepts/$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Concept.fromJson(json)).toList();
      } else {
        throw Exception('${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching concepts: $e');
    }
  }

  // Simulate a network call to create a concept
  Future<bool> createConcept(Concept concept) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return true; // Simulate successful creation
  }

}