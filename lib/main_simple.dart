// lib/main_simple.dart
// Diese Datei verwendet keine Datenbankverbindung oder komplexe Provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/tariftest_settings.dart';

void main() {
  print("=== App wird gestartet (einfache Version ohne Datenbank)... ===");
  runApp(const MySimpleApp());
}

class MySimpleApp extends StatelessWidget {
  const MySimpleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("MySimpleApp.build() wird aufgerufen");
    
    return ChangeNotifierProvider(
      create: (ctx) => TariftestSettings(),
      child: MaterialApp(
        title: 'Tariftest Manager (Einfache Version)',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const EmergencyStartScreen(),
      ),
    );
  }
}

class EmergencyStartScreen extends StatelessWidget {
  const EmergencyStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("EmergencyStartScreen.build() wird aufgerufen");
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariftest Manager - Notfallmodus'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                'App läuft im Notfallmodus',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Die Datenbankverbindung konnte nicht hergestellt werden. '
                'Die App läuft im eingeschränkten Modus ohne Datenbankfunktionen.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Diese Funktion ist im Notfallmodus nicht verfügbar.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Verkehrsunternehmen anzeigen'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Diese Funktion ist im Notfallmodus nicht verfügbar.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Tariftest-Einträge anzeigen'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Diese Funktion ist im Notfallmodus nicht verfügbar.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text('Tariftest durchführen'),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Diagnose-Informationen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.bug_report),
                label: const Text('Fehlerbericht erstellen'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Diagnose-Informationen'),
                      content: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Flutter-Version: 3.x.x'),
                            Text('Betriebssystem: macOS'),
                            Text('Datenbank: MySQL'),
                            Text('Konfiguration: Remote MySQL-Server'),
                            SizedBox(height: 10),
                            Text('Fehler: Datenbankverbindung konnte nicht hergestellt werden.'),
                            SizedBox(height: 10),
                            Text('Mögliche Ursachen:'),
                            Text('• Netzwerkverbindung nicht verfügbar'),
                            Text('• MySQL-Server nicht erreichbar'),
                            Text('• Falsche Zugangsdaten'),
                            Text('• Firewall blockiert Verbindung'),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Schließen'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}