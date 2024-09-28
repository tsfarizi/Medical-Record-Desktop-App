import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medgis_app/page/page/main_page.dart';
import 'package:medgis_app/utils/theme/theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String ip = '192.168.111.41';

  String pocketBasePath = '../pocketbase_0.22.20_windows_amd64/pocketbase.exe';

  Process pocketBaseProcess = await Process.start(
    pocketBasePath,
    ['serve', '--http=$ip:2003'],
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
      database: ip,
    ),
  ));

  ProcessSignal.sigint.watch().listen((signal) {
    pocketBaseProcess.kill();
  });
}
