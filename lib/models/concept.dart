

import 'package:myexpensesapp/models/category.dart';

class Concept {
  int? id;
  String? description;
  double? mount;
  DateTime? registrationDate;
  Category? category;

  Concept({this.id, this.description, this.mount, this.category, this.registrationDate});

  Concept.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    mount = (json['mount'] is num) ? (json['mount'] as num).toDouble() : double.tryParse(json['mount'].toString());
    registrationDate = DateTime.tryParse(json['registrationDate'] ?? '');
    category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['mount'] = mount;
    data['registrationDate'] = registrationDate.toString();
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  } 
}