import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medgis_app/page/page/main_page.dart';
import 'package:medgis_app/utils/theme/theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final info = NetworkInfo();
  String? ipAddress;

  try {
    ipAddress = await info.getWifiIP();
    ipAddress ??= await info.getWifiIP();
  } catch (e) {
    rethrow;
  }

  String baseUrl = '$ipAddress:2003';

  String pocketBasePath = '../pocketbase_0.22.20_windows_amd64/pocketbase.exe';

  try {
    Process pocketBaseProcess = await Process.start(
      pocketBasePath,
      ['serve', '--http=$baseUrl'],
      runInShell: true,
    );

    await Future.delayed(const Duration(seconds: 5));

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
        database: 'http://$baseUrl',
      ),
    ));

    ProcessSignal.sigint.watch().listen((signal) {
      pocketBaseProcess.kill();
    });
  } catch (e) {
    rethrow;
  }
}
