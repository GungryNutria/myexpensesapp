class AccountCreate {
  String? name;
  String? description;
  int? typeAccountId;
  int? userId;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'typeAccountId': typeAccountId,
      'userId': userId,
    };
  }
}