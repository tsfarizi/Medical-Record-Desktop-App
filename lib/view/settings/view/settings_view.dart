import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.7,
      child: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpansionTile(
              title: Row(
                children: [
                  Icon(Icons.data_object_rounded),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Database')
                ],
              ),
              children: [],
            ),
            ExpansionTile(
              title: Row(
                children: [
                  Icon(Icons.widgets_outlined),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Documentation')
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
