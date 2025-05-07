// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'models/tariftest_settings.dart';
import 'providers/verkehrsunternehmen_provider.dart';
import 'providers/verkehrsunternehmen_app_provider.dart';
import 'providers/tariftest_entry_provider.dart';
import 'views/start_screen.dart';
import 'views/verkehrsunternehmen_screen.dart';
import 'views/tariftest_entry_screen.dart';
import 'views/eingabe_tariftest_screen.dart';
import 'views/database_test_screen.dart';

void main() {
  // SQLite für Desktop (macOS) initialisieren
  sqfliteFfiInit();
  // Datenbank-Factory auf FFI setzen
  databaseFactory = databaseFactoryFfi;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Die Provider für die Daten bereitstellen
        ChangeNotifierProvider(create: (ctx) => TariftestSettings()),
        ChangeNotifierProvider(create: (ctx) => VerkehrsunternehmenProvider()),
        ChangeNotifierProvider(create: (ctx) => VerkehrsunternehmenAppProvider()),
        ChangeNotifierProvider(create: (ctx) => TariftestEntryProvider()),
      ],
      child: MaterialApp(
        title: 'Tariftest Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const StartScreen(),
        routes: {
          '/verkehrsunternehmen': (ctx) => const VerkehrsunternehmenScreen(),
          '/tariftest-entries': (ctx) => const TariftestEntriesScreen(),
          '/eingabe-tariftest': (ctx) => const EingabeTariftestScreen(),
          '/database-test': (ctx) => const DatabaseTestScreen(),
        },
      ),
    );
  }
}