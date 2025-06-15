import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myexpensesapp/bloc/concept/concept_bloc.dart';
import 'package:myexpensesapp/models/category.dart';
import 'package:myexpensesapp/models/concept.dart';
import 'package:myexpensesapp/models/concept_create.dart';
import 'package:myexpensesapp/utils/functions.dart';
import 'package:myexpensesapp/utils/theme_colors.dart';
import 'package:myexpensesapp/widgets/custom_button.dart';
import 'package:myexpensesapp/widgets/custom_dropdown.dart';
import 'package:myexpensesapp/widgets/custom_textfield.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLoading = false;
  late int accountId;
  late ConceptBloc conceptBloc;
  late Concept concept;
  late ConceptCreate conceptCreate;
  final _formKey = GlobalKey<FormState>();
  List<Category> categories = [];
  List<Concept> concepts = [];
  List<PieChartSectionData> pieConcepts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isLoading) {
      conceptCreate = ConceptCreate();
      concept = Concept();
      accountId = ModalRoute.of(context)!.settings.arguments as int;
      conceptBloc = BlocProvider.of<ConceptBloc>(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        conceptBloc.add(FetchConcepts(accountId));
      });
      isLoading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta $accountId'),
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {isLoading = false, Navigator.of(context).pop()},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          0.5,
        ),
        backgroundColor: ThemeColors.BLUE_DARK,
        onPressed: () => _addConcept(context, accountId),
        child: const Icon(
          Icons.add_chart_outlined,
          color: ThemeColors.BLUE_WHITE,
          size: 30,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${Functions.GetActualMonth()}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          BlocConsumer<ConceptBloc, ConceptState>(
            listener: (context, state) {
              if (state is ConceptSaved) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                if (state.concept != null) {
                  setState(() {
                    concepts.add(state.concept!);
                  });
                }
                Navigator.of(context).pop();
              } else if (state is ConceptError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is CategoriesError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is ConceptDeleted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                setState(() {
                  concepts.removeAt(state.index);
                });
              } else if (state is ConceptLoaded) {
                setState(() {
                  concepts = state.concepts;
                });
                conceptBloc.add(FetchCategories());
              } else if (state is CategoriesLoaded &&
                  state.categories.isNotEmpty) {
                setState(() {
                  categories = state.categories;
                });
              } else if (state is ConceptListEmpty) {
                conceptBloc.add(FetchCategories());
              }
            },
            builder: (context, state) {
              return BlocBuilder<ConceptBloc, ConceptState>(
                builder: (context, state) {
                  if (state is ConceptLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoriesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _showDashboard();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    return [
      PieChartSectionData(
        color: ThemeColors.BLUE_DARK,
        value: 1,
        title: '',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  void _addConcept(BuildContext context, int accountId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Concepto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          hintText: "Descripcion del Concepto",
                          onChanged: (value) => concept.description = value,
                        ),
                        CustomTextField(
                          hintText: "Monto del Concepto",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          onChanged:
                              (value) => {
                                concept.mount = double.tryParse(value) ?? 0.0,
                              },
                        ),

                        CustomDropdown<Category>(
                          items: _filterCategories(categories),
                          selectedItem: concept.category,
                          hintText: "Categoria",
                          onChanged:
                              (value) => {
                                if (value != null) {concept.category = value},
                              },
                        ),
                        CustomButton(
                          text: "Guardar Concepto",
                          onPressed: () => _createConcept(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showDashboard() {
    var onlyExpenses = _getOnlyExpenses(concepts);
    if (onlyExpenses.isEmpty) {
      pieConcepts = getSections();
    } else {
      final groupedData = Functions.getConceptsByCategory(onlyExpenses);
      pieConcepts = Functions.generatePieChartSections(groupedData);
    }

    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getInputs(concepts),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.green),
                  ),
                  Text(
                    _getOutputs(concepts),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.red),
                  ),
                ],
              ),

              AspectRatio(
                aspectRatio: 1.3,
                child: PieChart(
                  PieChartData(
                    sections: pieConcepts,
                    centerSpaceRadius: 80,
                    sectionsSpace: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: concepts.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(concepts[index].id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(
                          () => conceptBloc.add(
                            DeleteConcept(
                              conceptId: concepts[index].id!,
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          concepts[index].description ?? 'Sin Descripcion',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              concepts[index].category?.name ?? 'Sin Categoria',
                            ),
                          ],
                        ),

                        trailing: Text(
                          Functions.formatCurrency(
                            concepts[index].mount ?? 0.0,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color:
                                concepts[index].category?.operation == 0
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _createConcept() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      conceptCreate.description = concept.description;
      conceptCreate.mount = concept.mount;
      conceptCreate.categoryId =
          concept.category?.id; // Assuming category is not null
      conceptCreate.accountId =
          accountId; // Assuming user ID is 1 for now, replace with actual user ID logic
      conceptBloc.add(AddConcept(conceptCreate));
    }
  }

  List<Concept> _getOnlyExpenses(List<Concept> concepts) {
    return concepts
        .where((concept) => concept.category?.operation == 0)
        .toList();
  }

  List<Category> _filterCategories(List<Category> categories) {
    if (concepts.isEmpty) {
      var categoriesFiltered =
          categories.where((category) => category.operation == 1).toList();
      return categoriesFiltered;
    } else {
      return categories;
    }
  }

  String _getInputs(List<Concept> concepts) {
    var inputs =
        concepts.where((concept) => concept.category?.operation == 1).toList();
    var outputs =
        concepts.where((concept) => concept.category?.operation == 0).toList();
    if (concepts.isEmpty) {
      return "\$0.00";
    } else {
      double total =
          inputs.fold(0.0, (sum, concept) => sum + concept.mount!) -
          outputs.fold(0.0, (sum, concept) => sum + concept.mount!);
      final formatted = Functions.formatCurrency(total);
      return formatted;
    }
  }

  String _getOutputs(List<Concept> concepts) {
    var outputs =
        concepts.where((concept) => concept.category?.operation == 0).toList();
    if (concepts.isEmpty) {
      return "\$0.00";
    } else {
      double total = outputs.fold(0, (sum, concept) => sum + concept.mount!);
      final formatted = Functions.formatCurrency(total);
      return formatted;
    }
  }
}
