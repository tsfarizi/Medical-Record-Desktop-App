import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/bloc/main_cubit.dart';
import 'package:medgis_app/page/bloc/main_state.dart';
import 'package:medgis_app/page/widgets/button_section.dart';
import 'package:medgis_app/page/widgets/data_visualization_section.dart';
import 'package:medgis_app/page/widgets/table_section.dart';
import 'package:medgis_app/utils/theme/color_scheme.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _activeSelection = 1;

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    _activeSelection = 1;
                    context.read<MainCubit>().setState(QueueViewState());
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    _activeSelection == 1
                        ? colorScheme.primary.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 15,
                        child: _activeSelection == 1
                            ? const Icon(Icons.arrow_forward_rounded)
                            : Container()),
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
                  setState(() {
                    _activeSelection = 2;
                    context.read<MainCubit>().setState(HomeViewState());
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    _activeSelection == 2
                        ? colorScheme.primary.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 15,
                        child: _activeSelection == 2
                            ? const Icon(Icons.arrow_forward_rounded)
                            : Container()),
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
              TextButton(
                onPressed: () {
                  setState(() {
                    _activeSelection = 3;
                    context.read<MainCubit>().setState(SettingsViewState());
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    _activeSelection == 3
                        ? colorScheme.primary.withOpacity(0.2)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 15,
                        child: _activeSelection == 3
                            ? const Icon(Icons.arrow_forward_rounded)
                            : Container()),
                    const SizedBox(
                      width: 15,
                    ),
                    const Icon(Icons.settings_rounded),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Settings")
                  ],
                ),
              )
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
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.auto_awesome_motion_rounded,
                    color: colorScheme.primary,
                  ),
                  const Text("Documentation")
                ],
              ),
            ),
          )
        ],
      ),
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
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_motion_rounded,
                  color: colorScheme.primary,
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  "Component Documentation",
                  style: Theme.of(context).textTheme.headlineMedium,
                )
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
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.7,
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                TableSection(),
                ButtonSection(),
                DataVisualizationSection()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
