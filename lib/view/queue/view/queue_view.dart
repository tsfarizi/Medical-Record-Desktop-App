import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QueueView extends StatelessWidget {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Queue",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          width: 20,
        ),
        TextButton(
          onPressed: () {},
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded),
              SizedBox(
                width: 5,
              ),
              Text("Add Patient")
            ],
          ),
        ),
        Center(
            child: DataTable(
          columns: const [
            DataColumn(label: Text("No")),
            DataColumn(label: Text("Registraion Number")),
            DataColumn(label: Text("Name")),
            DataColumn(label: Text("Blood Pressure"))
          ],
          rows: const [],
        )),
      ],
    );
  }
}
