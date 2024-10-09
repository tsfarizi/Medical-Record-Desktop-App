import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medgis_app/page/page/main_page.dart';
import 'package:medgis_app/utils/theme/theme.dart';
import 'package:medgis_app/view/settings/bloc/settings_cubit.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isAdmin = await checkAdminPrivileges();
  if (!isAdmin) {
    await runAsAdmin();
    exit(0);
  }

  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    const Size initialSize = Size(1400, 800);
    await windowManager.setSize(initialSize);
    await windowManager.setMinimumSize(initialSize);
    await windowManager.setAlignment(Alignment.center);
    await windowManager.show();
  });

  runApp(
    BlocProvider(
      create: (context) => SettingsCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const MainPage(),
      ),
    ),
  );
}

Future<bool> checkAdminPrivileges() async {
  ProcessResult result = await Process.run('net', ['session']);
  return result.exitCode == 0;
}

Future<void> runAsAdmin() async {
  String executablePath = Platform.resolvedExecutable;
  String scriptPath = Platform.script.toFilePath();
  String command =
      'Start-Process -FilePath "$executablePath" -ArgumentList "$scriptPath" -Verb RunAs';
  await Process.start('powershell', ['-Command', command], runInShell: true);
}
