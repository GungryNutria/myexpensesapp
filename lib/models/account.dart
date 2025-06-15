import 'package:myexpensesapp/models/type_account.dart';

class Account {
  int? id;
  String? name;
  String? description;
  TypeAccount? typeAccount;

  Account({this.id, this.name, this.description, this.typeAccount});

  factory Account.fromJson(Map<String, dynamic> json) {
    
    return Account(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      typeAccount: TypeAccount.fromJson(json['typeAccount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'typeAccount': typeAccount?.toJson(),
    };
  }
}