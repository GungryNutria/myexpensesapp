part of 'concept_bloc.dart';

@immutable
abstract class ConceptEvent {}

class FetchCategories extends ConceptEvent {}
class FetchConcepts extends ConceptEvent {
  final int accountId;

  FetchConcepts(this.accountId);
}

class DeleteConcept extends ConceptEvent {
  final int conceptId;
  final int index;
  DeleteConcept({this.conceptId = 0, this.index = 0});
}

class AddConcept extends ConceptEvent {
  final ConceptCreate conceptCreate;

  AddConcept(this.conceptCreate);
}