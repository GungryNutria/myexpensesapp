class TypeAccount {
  int? id;
  String? name;

  TypeAccount({this.id, this.name});

  factory TypeAccount.fromJson(Map<String, dynamic> json) {
    return TypeAccount(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}