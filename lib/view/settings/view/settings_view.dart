import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/view/settings/bloc/settings_cubit.dart';
import 'package:medgis_app/view/settings/bloc/settings_state.dart';
import 'package:medgis_app/view/settings/widgets/button_section.dart';
import 'package:medgis_app/view/settings/widgets/data_visualization_section.dart';
import 'package:medgis_app/view/settings/widgets/table_section.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _serverIdController = TextEditingController();

  @override
  void dispose() {
    _serverIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.7,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpansionTile(
                  expandedAlignment: Alignment.centerLeft,
                  title: const Row(
                    children: [
                      Icon(Icons.data_object_rounded),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Database'),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Database Status:',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                settingsState.isDatabaseOn ? 'On' : 'Off',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Switch(
                            value: settingsState.isDatabaseOn,
                            onChanged: (bool value) {
                              context
                                  .read<SettingsCubit>()
                                  .toggleDatabase(value);
                            },
                          ),
                          const SizedBox(height: 25),
                          settingsState.isDatabaseOn
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Server running on server ID :'),
                                    Text(
                                      settingsState.serverId,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Server ID :'),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: TextFormField(
                                            controller: _serverIdController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter server id',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 100,
                                          child: TextButton(
                                            onPressed: () {
                                              final serverId =
                                                  _serverIdController.text
                                                      .trim();
                                              if (serverId.isNotEmpty) {
                                                context
                                                    .read<SettingsCubit>()
                                                    .connectWithServerId(
                                                        serverId);
                                              }
                                            },
                                            child: const Text(
                                              'Connect',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
                  ],
                ),
                const ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.widgets_outlined),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Documentation'),
                    ],
                  ),
                  children: [
                    TableSection(),
                    ButtonSection(),
                    DataVisualizationSection()
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
