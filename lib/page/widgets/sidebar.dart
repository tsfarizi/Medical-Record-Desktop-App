// sidebar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';
import 'package:medgis_app/view/settings/view/settings_view.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        int activeSelection;
        if (state is QueueViewState) {
          activeSelection = 1;
        } else if (state is HomeViewState) {
          activeSelection = 2;
        } else {
          activeSelection = 1;
        }

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          padding: const EdgeInsets.fromLTRB(5, 15, 0, 15),
          margin: const EdgeInsets.fromLTRB(25, 25, 0, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MainCubit>().setState(QueueViewState());
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        activeSelection == 1
                            ? colorScheme.primary.withOpacity(0.2)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                          child: activeSelection == 1
                              ? const Icon(Icons.arrow_forward_rounded)
                              : Container(),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(Icons.queue_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Queue")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MainCubit>().setState(HomeViewState());
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        activeSelection == 2
                            ? colorScheme.primary.withOpacity(0.2)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                          child: activeSelection == 2
                              ? const Icon(Icons.arrow_forward_rounded)
                              : Container(),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(Icons.dashboard_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Dashboard")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 25),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: colorScheme.surface),
                child: IconButton(
                  onPressed: () => _informationDialog(context),
                  icon: const Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.settings_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Settings")
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _informationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Icon(Icons.settings_rounded),
                SizedBox(
                  width: 10,
                ),
                Text("Settings")
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close_rounded, color: Colors.red),
            )
          ],
        ),
        content: const SettingsView(),
      ),
    );
  }
}
