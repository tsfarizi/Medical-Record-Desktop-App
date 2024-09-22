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
          columnSpacing: 30,
          columns: const [
            DataColumn(label: SizedBox(width: 20, child: Text("No"))),
            DataColumn(
                label: SizedBox(width: 150, child: Text("Registraion Number"))),
            DataColumn(label: SizedBox(width: 200, child: Text("Name"))),
            DataColumn(
                label: SizedBox(width: 120, child: Text("Blood Pressure")))
          ],
          rows: const [],
        )),
      ],
    );
  }
}
