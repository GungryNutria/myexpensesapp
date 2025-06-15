class ConceptCreate {
  String? description;
  double? mount;
  DateTime? registrationDate;
  int? categoryId;
  int? accountId;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'mount': mount,
      'registrationDate': DateTime.now().toIso8601String(),
      'categoryId': categoryId,
      'accountId': accountId,
    };
  }
}