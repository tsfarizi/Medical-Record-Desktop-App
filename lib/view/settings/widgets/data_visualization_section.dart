import 'package:flutter/material.dart';
import 'package:medgis_app/view/home/widgets/chart.dart';

class DataVisualizationSection extends StatelessWidget {
  const DataVisualizationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "C. Data Visualization",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Padding(
            padding: EdgeInsets.all(25),
            child: Card(
              child: Chart(
                  totalPatients: 100, malePatients: 63, femalePatients: 37),
            )),
        const Text(
            'The section on the main page of this application is responsible for describing the data owned, namely the number of patients and also the number of patients of each gender, and this section can also be used to describe data on a date by using the search bar.'),
        const Text(""),
        const Text(""),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Text(
            "This component is called a search bar that functions to search and also filter the data owned. This component can filter based on any data in the table, and when filtering the data visualization component will respond which makes the data depicted only data with criteria that match the characters typed in this search bar.")
      ],
    );
  }
}
