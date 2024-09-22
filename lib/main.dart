import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medgis_app/app.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String pocketBasePath = '../pocketbase_0.22.20_windows_amd64/pocketbase.exe';

  Process pocketBaseProcess = await Process.start(
    pocketBasePath,
    ['serve', '--http=192.168.43.41:2003'],
  );

  await Future.delayed(const Duration(seconds: 2));

  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    const Size initialSize = Size(1400, 800);
    await windowManager.setSize(initialSize);
    await windowManager.setMinimumSize(initialSize);
    await windowManager.setAlignment(Alignment.center);
    await windowManager.show();
  });

  runApp(const MedGISApp());

  ProcessSignal.sigint.watch().listen((signal) {
    pocketBaseProcess.kill();
  });
}
