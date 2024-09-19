import 'package:flutter/material.dart';
import 'package:medgis_app/app.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    const Size initialSize = Size(1200, 800);
    await windowManager.setSize(initialSize);

    await windowManager.setMinimumSize(initialSize);

    await windowManager.setAlignment(Alignment.center);

    await windowManager.show();
  });

  runApp(const MedGISApp());
}
