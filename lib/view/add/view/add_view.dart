import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/view/add/widgets/add_patient_form.dart';

class AddView extends StatelessWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            context.read<MainCubit>().setState(HomeViewState());
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      context.read<MainCubit>().setState(HomeViewState());
                    },
                    icon: const Icon(Icons.arrow_back_rounded)),
                const SizedBox(width: 8),
                const Text(
                  "Add Patient",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            const AddPatientForm(),
          ],
        ));
  }
}
