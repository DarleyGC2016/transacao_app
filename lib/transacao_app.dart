import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screen/home/home_page.dart';

class TransacaoApp extends StatelessWidget {
  const TransacaoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      locale: Locale("pt", "BR"),
      supportedLocales: [Locale("pt", "BR")],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomePage(title: 'Transações Financeiras'),
    );
  }
}
