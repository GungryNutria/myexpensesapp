

import 'package:myexpensesapp/models/category.dart';

class Concept {
  int? id;
  String? description;
  double? mount;
  Category? category;

  Concept({this.id, this.description, this.mount, this.category});

  Concept.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    mount = json['mount'];
    category = Category.fromJson(json['category']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['mount'] = mount;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  } 
}