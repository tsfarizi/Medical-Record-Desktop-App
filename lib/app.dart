import 'package:flutter/material.dart';
import 'package:medgis_app/page/page/main_page.dart';
import 'package:medgis_app/utils/theme/theme.dart';

class MedGISApp extends StatelessWidget {
  const MedGISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const MainPage(),
    );
  }
}
