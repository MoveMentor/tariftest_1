// lib/providers/verkehrsunternehmen_provider.dart
import 'package:flutter/foundation.dart';
import '../models/verkehrsunternehmen.dart';
import '../services/database_service.dart';

class VerkehrsunternehmenProvider with ChangeNotifier {
  // Liste der Verkehrsunternehmen im Speicher
  List<Verkehrsunternehmen> _unternehmen = [];
  
  // Instanz des DatabaseService
  final DatabaseService _dbService = DatabaseService();
  
  // Flag, um zu prüfen, ob die Daten bereits geladen wurden
  bool _isLoaded = false;
  bool _isLoading = false;

  // Getter für die Liste
  List<Verkehrsunternehmen> get unternehmen => [..._unternehmen];
  
  // Status-Getter
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  // Konstruktor
  VerkehrsunternehmenProvider() {
    // Beim Erstellen des Providers die Daten aus der Datenbank laden
    loadUnternehmen();
  }

  // Daten aus der Datenbank laden
Future<void> loadUnternehmen() async {
  _isLoading = true;
  notifyListeners();
  
  try {
    // Daten aus der Datenbank abrufen
    final loadedUnternehmen = await _dbService.getAllVerkehrsunternehmen();
    _unternehmen = loadedUnternehmen;
    _isLoaded = true;
  } catch (e) {
    print('Fehler beim Laden der Verkehrsunternehmen: $e');
    // Im Fehlerfall Demo-Daten verwenden
    addDemoData();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Unternehmen hinzufügen
  Future<void> addUnternehmen(Verkehrsunternehmen unternehmen) async {
    try {
      // Zuerst in die Datenbank einfügen
      final success = await _dbService.addVerkehrsunternehmen(unternehmen);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch im lokalen Speicher
        _unternehmen.add(unternehmen);
        notifyListeners();
      } else {
        print('Fehler: Unternehmen konnte nicht in die Datenbank eingefügt werden');
      }
    } catch (error) {
      print('Fehler beim Hinzufügen des Unternehmens: $error');
      // Im Fehlerfall trotzdem lokal hinzufügen
      _unternehmen.add(unternehmen);
      notifyListeners();
    }
  }

  // Unternehmen löschen
  Future<void> deleteUnternehmen(String id) async {
    try {
      // Zuerst aus der Datenbank löschen
      final success = await _dbService.deleteVerkehrsunternehmen(id);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch aus dem lokalen Speicher entfernen
        _unternehmen.removeWhere((unternehmen) => unternehmen.id == id);
        notifyListeners();
      } else {
        print('Fehler: Unternehmen konnte nicht aus der Datenbank gelöscht werden');
      }
    } catch (error) {
      print('Fehler beim Löschen des Unternehmens: $error');
      // Im Fehlerfall trotzdem lokal löschen
      _unternehmen.removeWhere((unternehmen) => unternehmen.id == id);
      notifyListeners();
    }
  }

  // Unternehmen aktualisieren
  Future<void> updateUnternehmen(Verkehrsunternehmen updatedUnternehmen) async {
    try {
      // Zuerst in der Datenbank aktualisieren
      final success = await _dbService.updateVerkehrsunternehmen(updatedUnternehmen);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch im lokalen Speicher
        final index = _unternehmen.indexWhere((unternehmen) => unternehmen.id == updatedUnternehmen.id);
        if (index >= 0) {
          _unternehmen[index] = updatedUnternehmen;
          notifyListeners();
        }
      } else {
        print('Fehler: Unternehmen konnte nicht in der Datenbank aktualisiert werden');
      }
    } catch (error) {
      print('Fehler beim Aktualisieren des Unternehmens: $error');
      // Im Fehlerfall trotzdem lokal aktualisieren
      final index = _unternehmen.indexWhere((unternehmen) => unternehmen.id == updatedUnternehmen.id);
      if (index >= 0) {
        _unternehmen[index] = updatedUnternehmen;
        notifyListeners();
      }
    }
  }

  // Unternehmen nach ID finden
  Verkehrsunternehmen? findById(String id) {
    try {
      return _unternehmen.firstWhere((unternehmen) => unternehmen.id == id);
    } catch (e) {
      return null;
    }
  }

  // Für Demo-Zwecke: Beispieldaten hinzufügen
  void addDemoData() {
    if (_unternehmen.isEmpty) {
      final demoUnternehmen = [
        Verkehrsunternehmen(
          id: '1',
          name: 'Deutsche Bahn',
          kuerzel: 'DB',
          kontakt: 'info@bahn.de',
          adresse: 'Potsdamer Platz 2, Berlin',
        ),
        Verkehrsunternehmen(
          id: '2',
          name: 'BVG',
          kuerzel: 'BVG',
          kontakt: 'info@bvg.de',
          adresse: 'Holzmarktstraße 15-17, Berlin',
        ),
        Verkehrsunternehmen(
          id: '3',
          name: 'MVG München',
          kuerzel: 'MVG',
          kontakt: 'info@mvg.de',
          adresse: 'Emmy-Noether-Straße 2, München',
        ),
        Verkehrsunternehmen(
          id: '4',
          name: 'WSW mobil GmbH',
          kuerzel: 'WSW',
          kontakt: 'info@wsw-online.de',
          adresse: 'Bromberger Str. 39-41, 42281 Wuppertal',
        ),
      ];
      
      // Demo-Daten zu lokaler Liste hinzufügen
      _unternehmen = demoUnternehmen;
      notifyListeners();
      
      // Anschließend versuchen, die Demo-Daten in die Datenbank zu schreiben
      for (var unternehmen in demoUnternehmen) {
        _dbService.addVerkehrsunternehmen(unternehmen).catchError((error) {
          print('Fehler beim Hinzufügen von Demo-Daten zur Datenbank: $error');
        });
      }
    }
  }

  // Datenbankverbindung testen
  Future<bool> testConnection() async {
    return await _dbService.testConnection();
  }
}