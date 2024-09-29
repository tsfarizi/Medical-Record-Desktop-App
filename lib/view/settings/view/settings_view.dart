import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDatabaseOn = false;

  @override
  Widget build(BuildContext context) {
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
                          Text(
                            'Database Status:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isDatabaseOn ? 'On' : 'Off',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Switch(
                        value: isDatabaseOn,
                        onChanged: (bool value) {
                          setState(() {
                            isDatabaseOn = value;
                          });
                        },
                      ),
                      const SizedBox(height: 25),
                      isDatabaseOn
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Server running on server ID :'),
                                SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    readOnly: true,
                                  ),
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
                                      width: 50,
                                      child: TextFormField(),
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: 100,
                                      child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            'Connect',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )),
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
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
