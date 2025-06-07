class Category {
  int? id;
  String? name;
  int? operation;

  Category({this.id, this.name, this.operation});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    operation = json['operation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['operation'] = operation;
    return data;
  }
}