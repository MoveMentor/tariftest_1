// lib/views/start_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/tariftest_settings.dart';
import '../providers/verkehrsunternehmen_provider.dart';
import '../providers/verkehrsunternehmen_app_provider.dart';
import 'database_test_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _testerNameController = TextEditingController();
  bool _isConfigured = false;
  
  @override
  void initState() {
    super.initState();
    
    // Verzögerte Ausführung, um Provider.of nach dem Build auszuführen
    Future.microtask(() {
      final settings = Provider.of<TariftestSettings>(context, listen: false);
      final verkehrsunternehmenProvider = Provider.of<VerkehrsunternehmenProvider>(context, listen: false);
      
      // Stellen Sie sicher, dass Demo-Daten geladen sind
      verkehrsunternehmenProvider.loadUnternehmen();
      
      // Überprüfen, ob die App bereits konfiguriert ist
      if (settings.testerName != null) {
        _testerNameController.text = settings.testerName!;
      }
      
      setState(() {
        _isConfigured = settings.isComplete;
      });
    });
  }

  @override
  void dispose() {
    _testerNameController.dispose();
    super.dispose();
  }

  void _saveTesterName() {
    if (_testerNameController.text.trim().isEmpty) {
      // Wenn kein Name eingegeben wurde, eine Warnung anzeigen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte geben Sie Ihren Namen ein'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Tester-Namen speichern
    final settings = Provider.of<TariftestSettings>(context, listen: false);
    settings.setTesterName(_testerNameController.text.trim());
    
    // UI aktualisieren
    setState(() {
      _isConfigured = settings.isComplete;
    });
  }

  void _showMonthPicker() async {
  // Liste der Monate anzeigen statt DatePicker
  final settings = Provider.of<TariftestSettings>(context, listen: false);
  final DateTime now = DateTime.now();
  
  final List<Widget> monthOptions = [];
  for (int i = 0; i < 24; i++) {
    int year = now.year + (now.month + i - 1) ~/ 12;
    int month = (now.month + i - 1) % 12 + 1;
    final dateTime = DateTime(year, month, 1);
    final monthName = DateFormat('MMMM yyyy').format(dateTime);
    
    monthOptions.add(
      ListTile(
        title: Text(monthName),
        onTap: () {
          settings.setSelectedMonth(dateTime);
          setState(() {
            _isConfigured = settings.isComplete;
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Monat auswählen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: monthOptions,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    // Zugriff auf die Settings und Provider
    final settings = Provider.of<TariftestSettings>(context);
    final unternehmenProvider = Provider.of<VerkehrsunternehmenProvider>(context);
    final appProvider = Provider.of<VerkehrsunternehmenAppProvider>(context);
    
    // Liste der Verkehrsunternehmen
    final unternehmen = unternehmenProvider.unternehmen;
    
    // Liste der Apps für das ausgewählte Verkehrsunternehmen
    final List<DropdownMenuItem<String>> appItems = settings.verkehrsunternehmenId != null
      ? appProvider.findByVerkehrsunternehmen(settings.verkehrsunternehmenId!).map((app) {
          return DropdownMenuItem<String>(
            value: app.id,
            child: Text(app.name),
          );
        }).toList()
      : [];
      
    // Wenn keine Apps gefunden wurden, eine leere Option hinzufügen
    if (appItems.isEmpty) {
      appItems.add(const DropdownMenuItem<String>(
        value: '',
        child: Text('Keine Apps verfügbar'),
      ));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariftest Manager'),
        actions: [
          // Datenbank-Test-Button
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DatabaseTestScreen()),
              );
            },
            tooltip: 'Datenbank-Verwaltung',
          ),
          // Verkehrsunternehmen-Verwaltung-Button
          IconButton(
            icon: const Icon(Icons.business),
            onPressed: () {
              Navigator.pushNamed(context, '/verkehrsunternehmen');
            },
            tooltip: 'Verkehrsunternehmen verwalten',
          ),
          // Testfälle-Verwaltung-Button
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {
              Navigator.pushNamed(context, '/tariftest-entries');
            },
            tooltip: 'Testfälle verwalten',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel
              const Text(
                'Willkommen beim Tariftest Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Beschreibung
              const Text(
                'Bitte konfigurieren Sie die Grundeinstellungen für Ihre Tariftests:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              // Eingabefeld für Tester-Namen
              TextField(
                controller: _testerNameController,
                decoration: InputDecoration(
                  labelText: 'Ihr Name',
                  hintText: 'Geben Sie Ihren Namen ein',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveTesterName,
                    tooltip: 'Namen speichern',
                  ),
                ),
                onSubmitted: (_) => _saveTesterName(),
              ),
              const SizedBox(height: 16),
              
              // Monats-Auswahl
              InkWell(
                onTap: _showMonthPicker,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Testmonat',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        settings.selectedMonth != null
                            ? DateFormat('MMMM yyyy').format(settings.selectedMonth!)
                            : 'Monat auswählen',
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Verkehrsunternehmen-Auswahl
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Verkehrsunternehmen',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(),
                ),
                value: settings.verkehrsunternehmenId,
                onChanged: (value) {
                  if (value != null) {
                    settings.setVerkehrsunternehmen(value);
                  }
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Bitte auswählen'),
                  ),
                  // Liste der Verkehrsunternehmen
                  ...unternehmen.map((unternehmen) {
                    return DropdownMenuItem<String>(
                      value: unternehmen.id,
                      child: Text(
                        '${unternehmen.name} (${unternehmen.kuerzel})'
                      ),
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 16),
              
              // App-Auswahl (nur aktiviert, wenn ein Verkehrsunternehmen ausgewählt wurde)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'App',
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(),
                ),
                value: settings.appId,
                onChanged: settings.verkehrsunternehmenId != null
                    ? (value) {
                        if (value != null && value.isNotEmpty) {
                          settings.setApp(value);
                        }
                      }
                    : null,
                items: appItems,
              ),
              const SizedBox(height: 32),
              
              // Button zum Starten des Tariftests
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isConfigured ? () {
                    Navigator.pushNamed(context, '/eingabe-tariftest');
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Tariftest starten',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              
              // Hinweis, wenn nicht alle Einstellungen konfiguriert sind
              if (!_isConfigured)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bitte vervollständigen Sie alle Einstellungen, um den Tariftest zu starten.',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}