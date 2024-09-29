import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medgis_app/page/page/main_page.dart';
import 'package:medgis_app/utils/theme/theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String baseUrl = '192.168.25.41:2003';

  String pocketBasePath = '../pocketbase_0.22.20_windows_amd64/pocketbase.exe';

  Process pocketBaseProcess = await Process.start(
    pocketBasePath,
    ['serve', '--http=$baseUrl'],
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

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: themeData,
    home: MainPage(
      database: baseUrl,
    ),
  ));

  ProcessSignal.sigint.watch().listen((signal) {
    pocketBaseProcess.kill();
  });
}
