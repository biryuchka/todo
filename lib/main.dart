import 'package:flutter/material.dart';
import 'package:todo/UI/homepage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo/util/logger.dart';
import 'package:flutter/foundation.dart';


void main() {
  if (kReleaseMode) {
    MyLogger.disable();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr')
      ],
      theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Roboto',
      ),
      title: 'DoDidDone',
      home: HomePage(),
    );
  }
}