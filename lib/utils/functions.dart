import 'dart:convert';
import 'dart:ui';

import 'package:bcrypt/bcrypt.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:myexpensesapp/models/concept.dart';
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

  static Map<String, double> getConceptsByCategory(List<Concept> concepts) {
    final Map<String, double> categories = {};
    for (var concept in concepts){
      if(concept.category?.name != null && concept.mount != null) {
        final categoryName = concept.category!.name!;
        categories[categoryName] = (categories[categoryName] ?? 0) + concept.mount!;
      }
    }
    return categories;
  }

  static List<PieChartSectionData> generatePieChartSections(
    Map<String, double> data,
  ) {
    final colors = Constants.pieColors;
    int colorIndex = 0;
    double total = data.values.fold(0, (a, b) => a + b);

    return data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final section = PieChartSectionData(
        color: colors[colorIndex % colors.length],
        value: entry.value,
        title: '${entry.key} ',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      colorIndex++;
      return section;
    }).toList();
  }

  static String formatCurrency(double value) {
    final formatter = NumberFormat.simpleCurrency(locale: 'en_US');
    return formatter.format(value);
  }
}