// lib/views/database_test_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verkehrsunternehmen_provider.dart';
import '../providers/verkehrsunternehmen_app_provider.dart';
import '../providers/tariftest_entry_provider.dart';
import '../services/database_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({Key? key}) : super(key: key);

  @override
  _DatabaseTestScreenState createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  bool _isTesting = false;
  String _statusMessage = 'Datenbankverbindung wurde noch nicht getestet.';
  bool _isConnected = false;
  
  final DatabaseService _dbService = DatabaseService();

  // Testet die Datenbankverbindung
  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _statusMessage = 'Teste Verbindung...';
    });

    try {
      final isConnected = await _dbService.testConnection();
      
      setState(() {
        _isConnected = isConnected;
        _statusMessage = isConnected 
          ? 'Verbindung zur Datenbank erfolgreich hergestellt!' 
          : 'Verbindung zur Datenbank konnte nicht hergestellt werden.';
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _statusMessage = 'Fehler beim Testen der Datenbankverbindung: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  // Lädt alle Daten aus der Datenbank
  Future<void> _loadAllData() async {
    setState(() {
      _isTesting = true;
      _statusMessage = 'Lade Daten aus der Datenbank...';
    });

    try {
      // Zugriff auf die Provider
      final verkehrsunternehmenProvider = Provider.of<VerkehrsunternehmenProvider>(context, listen: false);
      final appProvider = Provider.of<VerkehrsunternehmenAppProvider>(context, listen: false);
      final tariftestProvider = Provider.of<TariftestEntryProvider>(context, listen: false);
      
      // Daten neu laden
      await verkehrsunternehmenProvider.loadUnternehmen();
      await appProvider.loadApps();
      await tariftestProvider.loadEntries();
      
      setState(() {
        _statusMessage = 'Alle Daten erfolgreich aus der Datenbank geladen!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Fehler beim Laden der Daten: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  // Initialisiert die Datenbank mit Demo-Daten
  Future<void> _initializeWithDemoData() async {
    setState(() {
      _isTesting = true;
      _statusMessage = 'Initialisiere Datenbank mit Demo-Daten...';
    });

    try {
      // Zugriff auf die Provider
      final verkehrsunternehmenProvider = Provider.of<VerkehrsunternehmenProvider>(context, listen: false);
      final appProvider = Provider.of<VerkehrsunternehmenAppProvider>(context, listen: false);
      final tariftestProvider = Provider.of<TariftestEntryProvider>(context, listen: false);
      
      // Demo-Daten hinzufügen
      verkehrsunternehmenProvider.addDemoData();
      appProvider.addDemoData();
      tariftestProvider.addDemoData();
      
      setState(() {
        _statusMessage = 'Datenbank erfolgreich mit Demo-Daten initialisiert!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Fehler beim Initialisieren mit Demo-Daten: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datenbank-Verbindungstest'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status-Anzeige
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isConnected ? Colors.green.shade200 : Colors.orange.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isConnected ? Icons.check_circle : Icons.info,
                        color: _isConnected ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Datenbankstatus:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_statusMessage),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Aktionen
            const Text(
              'Aktionen:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Test-Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isTesting ? null : _testConnection,
                icon: const Icon(Icons.sync),
                label: const Text('Datenbankverbindung testen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Daten laden Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_isTesting || !_isConnected) ? null : _loadAllData,
                icon: const Icon(Icons.cloud_download),
                label: const Text('Alle Daten aus der Datenbank laden'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Datenbank initialisieren Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_isTesting || !_isConnected) ? null : _initializeWithDemoData,
                icon: const Icon(Icons.dataset),
                label: const Text('Datenbank mit Demo-Daten initialisieren'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Hinweis
            if (_isConnected)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Hinweis:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Die Anwendung synchronisiert Daten automatisch mit der Datenbank. '
                      'Alle Änderungen werden in der Datenbank gespeichert und stehen '
                      'nach dem Neustart der Anwendung wieder zur Verfügung.'
                    ),
                  ],
                ),
              ),
              
              if (_isTesting)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}