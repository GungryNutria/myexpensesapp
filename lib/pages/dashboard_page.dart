import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myexpensesapp/models/concept.dart';
import 'package:myexpensesapp/services/concept_service.dart';
import 'package:myexpensesapp/utils/functions.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int accountId = ModalRoute.of(context)!.settings.arguments as int;
    ConceptService conceptService = ConceptService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuenta $accountId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
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
          FutureBuilder(
            future: conceptService.getConcepts(accountId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No concepts found.');
              } else {
                final concepts = getSections(snapshot.data!);
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sections: concepts,
                          centerSpaceRadius: 50,
                          sectionsSpace: 3,
                        ) 
                      ),
                    ),
                  ],
                );
              }
            },
          )
        ]),
    );
  }

  List<PieChartSectionData> getSections(List<Concept> concepts) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.purple];
    return concepts.asMap().entries.map((entry) {
      int index = entry.key;
      Concept concept = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: concept.mount,
        title: concept.description,
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
