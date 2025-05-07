// lib/providers/tariftest_entry_provider.dart
import 'package:flutter/foundation.dart';
import '../models/tariftest_entry.dart';
import '../services/database_service.dart';

class TariftestEntryProvider with ChangeNotifier {
  // Liste der Tariftest-Einträge
  List<TariftestEntry> _entries = [];
  
  // Instanz des DatabaseService
  final DatabaseService _dbService = DatabaseService();
  
  // Status-Flags
  bool _isLoaded = false;
  bool _isLoading = false;

  // Liste der verfügbaren VRR-Ticketarten
  // In der Zukunft könnte dies aus einer Datenbank geladen werden
  final List<String> _ticketArten = [
    'EinzelTicket',
    '4er-Ticket',
    '24-StundenTicket',
    '24-StundenTicket (5 Personen)',
    'Wochenendticket',
    'ZusatzTicket',
    'FahrradTicket',
    'MonatsTicket',
    'Ticket2000',
    'YoungTicketPLUS',
    'BärenTicket',
    'SchokoTicket',
  ];

  // Getter für die Listen
  List<TariftestEntry> get entries => [..._entries];
  List<String> get ticketArten => [..._ticketArten];
  
  // Status-Getter
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  // Konstruktor
  TariftestEntryProvider() {
    // Beim Erstellen des Providers die Daten aus der Datenbank laden
    loadEntries();
  }

  // Einträge aus der Datenbank laden
  Future<void> loadEntries() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Daten aus der Datenbank abrufen
      final loadedEntries = await _dbService.getAllTariftestEntries();
      _entries = loadedEntries;
      _isLoaded = true;
    } catch (error) {
      print('Fehler beim Laden der Tariftest-Einträge: $error');
      // Im Fehlerfall Demo-Daten verwenden, falls keine Daten geladen wurden
      if (_entries.isEmpty) {
        addDemoData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eintrag hinzufügen
  Future<void> addEntry(TariftestEntry entry) async {
    try {
      // Zuerst in die Datenbank einfügen
      final success = await _dbService.addTariftestEntry(entry);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch im lokalen Speicher
        _entries.add(entry);
        notifyListeners();
      } else {
        print('Fehler: Tariftest-Eintrag konnte nicht in die Datenbank eingefügt werden');
      }
    } catch (error) {
      print('Fehler beim Hinzufügen des Tariftest-Eintrags: $error');
      // Im Fehlerfall trotzdem lokal hinzufügen
      _entries.add(entry);
      notifyListeners();
    }
  }

  // Eintrag löschen
  Future<void> deleteEntry(String id) async {
    try {
      // Zuerst aus der Datenbank löschen
      final success = await _dbService.deleteTariftestEntry(id);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch aus dem lokalen Speicher entfernen
        _entries.removeWhere((entry) => entry.id == id);
        notifyListeners();
      } else {
        print('Fehler: Tariftest-Eintrag konnte nicht aus der Datenbank gelöscht werden');
      }
    } catch (error) {
      print('Fehler beim Löschen des Tariftest-Eintrags: $error');
      // Im Fehlerfall trotzdem lokal löschen
      _entries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    }
  }

  // Eintrag nach ID finden
  TariftestEntry? findById(String id) {
    try {
      return _entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }

  // Eintrag aktualisieren
  Future<void> updateEntry(TariftestEntry updatedEntry) async {
    try {
      // Zuerst in der Datenbank aktualisieren
      final success = await _dbService.updateTariftestEntry(updatedEntry);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch im lokalen Speicher
        final index = _entries.indexWhere((entry) => entry.id == updatedEntry.id);
        if (index >= 0) {
          _entries[index] = updatedEntry;
          notifyListeners();
        }
      } else {
        print('Fehler: Tariftest-Eintrag konnte nicht in der Datenbank aktualisiert werden');
      }
    } catch (error) {
      print('Fehler beim Aktualisieren des Tariftest-Eintrags: $error');
      // Im Fehlerfall trotzdem lokal aktualisieren
      final index = _entries.indexWhere((entry) => entry.id == updatedEntry.id);
      if (index >= 0) {
        _entries[index] = updatedEntry;
        notifyListeners();
      }
    }
  }

  // Für Demo-Zwecke: Beispieldaten hinzufügen
  void addDemoData() {
    if (_entries.isEmpty) {
      final demoEntries = [
        TariftestEntry(
          id: '1',
          fallnummer: 'TF001',
          typ: 'iOS',
          systemdienstleister: 'HanseCom',
          ebene: 'Katalog-Kauf',
          preisstufe: 'Pst. A',
          startort: 'Hamburg Hbf',
          zielort: 'Hamburg Altona',
          personenanzahl: 1,
          istKind: false,
          ticketart: 'EinzelTicket',
        ),
        TariftestEntry(
          id: '2',
          fallnummer: 'TF002',
          typ: 'Android',
          systemdienstleister: 'Mentz',
          ebene: 'Routen-Kauf',
          preisstufe: 'Pst. B',
          startort: 'Berlin Hbf',
          zielort: 'Berlin Ostkreuz',
          personenanzahl: 2,
          istKind: true,
          ticketart: '24-StundenTicket',
        ),
        TariftestEntry(
          id: '3',
          fallnummer: 'TF003',
          typ: 'iOS',
          systemdienstleister: 'ICA',
          ebene: 'Katalog-Kauf',
          preisstufe: 'Pst. C',
          startort: 'Wuppertal Hbf',
          zielort: 'Wuppertal Zoo',
          personenanzahl: 3,
          istKind: false,
          ticketart: '4er-Ticket',
        ),
        TariftestEntry(
          id: '4',
          fallnummer: 'TF004',
          typ: 'Android',
          systemdienstleister: 'Digital H',
          ebene: 'Routen-Kauf',
          preisstufe: 'Pst. A',
          startort: 'München Hbf',
          zielort: 'München Ost',
          personenanzahl: 1,
          istKind: true,
          ticketart: 'ZusatzTicket',
        ),
      ];
      
      // Demo-Daten zu lokaler Liste hinzufügen
      _entries = demoEntries;
      notifyListeners();
      
      // Anschließend versuchen, die Demo-Daten in die Datenbank zu schreiben
      for (var entry in demoEntries) {
        _dbService.addTariftestEntry(entry).catchError((error) {
          print('Fehler beim Hinzufügen von Demo-Tariftest-Daten zur Datenbank: $error');
        });
      }
    }
  }
}