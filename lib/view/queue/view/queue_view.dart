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
        Text(DateFormat('yyyy-MM-dd').format(DateTime.now()))
      ],
    );
  }
}
