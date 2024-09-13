import 'package:flutter/material.dart';
import 'package:medgis_app/app.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setSize(const Size(1200, 800));

    await windowManager.setAlignment(Alignment.center);

    await windowManager.show();
  });

  runApp(const MedGISApp());
}
