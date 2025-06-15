part of 'concept_bloc.dart';

@immutable
abstract class ConceptState {}

class ConceptInitial extends ConceptState {}
class ConceptLoading extends ConceptState {}
class ConceptLoaded extends ConceptState {
  final List<Concept> concepts;

  ConceptLoaded(this.concepts);
}
class ConceptSaved extends ConceptState {
  final String message;
  final Concept? concept;
  ConceptSaved({required this.message, this.concept});
}

class ConceptError extends ConceptState {
  final String message;
  ConceptError(this.message);
}
class ConceptListEmpty extends ConceptState {}
class CategoriesLoading extends ConceptState {}
class CategoriesLoaded extends ConceptState {
  final List<Category> categories;

  CategoriesLoaded(this.categories);
}
class CategoriesError extends ConceptState {
  final String message;
  CategoriesError(this.message);
}

class ConceptDeleted extends ConceptState {
  final String message;
  final int index;

  ConceptDeleted({required this.message, required this.index});
}
