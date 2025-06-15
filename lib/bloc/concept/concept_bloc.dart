import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:myexpensesapp/models/category.dart';
import 'package:myexpensesapp/models/concept.dart';
import 'package:myexpensesapp/models/concept_create.dart';
import 'package:myexpensesapp/models/error_details.dart';
import 'package:myexpensesapp/services/concept_service.dart';

part 'concept_event.dart';
part 'concept_state.dart';

class ConceptBloc extends Bloc<ConceptEvent, ConceptState> {
  final ConceptService conceptService = ConceptService();
  ConceptBloc() : super(ConceptInitial()) {
    on<FetchConcepts>(_fetchConcepts);
    on<FetchCategories>(_fetchCategories);
    on<AddConcept>(_addConcept);
    on<DeleteConcept>(_deleteConcept);
  }

  FutureOr<void> _fetchConcepts(
    FetchConcepts event,
    Emitter<ConceptState> emit,
  ) async {
    try {
      emit(ConceptLoading());
      var response = await conceptService.getConcepts(event.accountId);
      if (response.isEmpty) {
        emit(ConceptListEmpty());
      } else {
        emit(ConceptLoaded(response));
      }
    } catch (e) {
      emit(ConceptError(e.toString()));
    }
  }



  FutureOr<void> _fetchCategories(FetchCategories event, Emitter<ConceptState> emit) async{
    try {
      emit(CategoriesLoading());
      var response = await conceptService.getCategories();
      if (response is List<Category>) {
        emit(CategoriesLoaded(response));
      } else if (response is Errordetails) {
        emit(CategoriesError(response.message!));
      }
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  Future<void> _addConcept(AddConcept event, Emitter<ConceptState> emit) async {
    try {
      emit(ConceptLoading());
      var response = await conceptService.addConcept(event.conceptCreate);
      if (response is Concept) {
        emit(ConceptSaved(message: "Concept created successfully", concept: response));
      } else if (response is Errordetails) {
        emit(ConceptError(response.message!));
      }
    } catch (e) {
      emit(ConceptError(e.toString()));
    }
  }

  FutureOr<void> _deleteConcept(DeleteConcept event, Emitter<ConceptState> emit) async{
    try {
      emit(ConceptLoading());
      var response = await conceptService.deleteConcept(event.conceptId);
      if (response is bool && response) {
        emit(ConceptDeleted(message: "Concept deleted successfully", index: event.index));
      } else if (response is Errordetails) {
        emit(ConceptError(response.message!));
      }
    } catch (e) {
      
    }
  }
}
