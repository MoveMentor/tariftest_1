// lib/providers/verkehrsunternehmen_app_provider.dart
import 'package:flutter/foundation.dart';
import '../models/verkehrsunternehmen_app.dart';
import '../services/database_service.dart';

class VerkehrsunternehmenAppProvider with ChangeNotifier {
  // Liste der Apps
  List<VerkehrsunternehmenApp> _apps = [];
  
  // Instanz des DatabaseService
  final DatabaseService _dbService = DatabaseService();
  
  // Status-Flags
  bool _isLoaded = false;
  bool _isLoading = false;

  // Getter für die Liste
  List<VerkehrsunternehmenApp> get apps => [..._apps];
  
  // Status-Getter
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  // Konstruktor
  VerkehrsunternehmenAppProvider() {
    // Beim Erstellen des Providers die Daten aus der Datenbank laden
    loadApps();
  }

  // Alle Apps aus der Datenbank laden
  Future<void> loadApps() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Daten aus der Datenbank abrufen
      final loadedApps = await _dbService.getAllVerkehrsunternehmenApps();
      _apps = loadedApps;
      _isLoaded = true;
    } catch (error) {
      print('Fehler beim Laden der Apps: $error');
      // Im Fehlerfall Demo-Daten verwenden, falls keine Daten geladen wurden
      if (_apps.isEmpty) {
        addDemoData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // App hinzufügen
  Future<void> addApp(VerkehrsunternehmenApp app) async {
    try {
      // Zuerst in die Datenbank einfügen
      final success = await _dbService.addVerkehrsunternehmenApp(app);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch im lokalen Speicher
        _apps.add(app);
        notifyListeners();
      } else {
        print('Fehler: App konnte nicht in die Datenbank eingefügt werden');
      }
    } catch (error) {
      print('Fehler beim Hinzufügen der App: $error');
      // Im Fehlerfall trotzdem lokal hinzufügen
      _apps.add(app);
      notifyListeners();
    }
  }

  // App löschen
  Future<void> deleteApp(String id) async {
    try {
      // Zuerst aus der Datenbank löschen
      final success = await _dbService.deleteVerkehrsunternehmenApp(id);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch aus dem lokalen Speicher entfernen
        _apps.removeWhere((app) => app.id == id);
        notifyListeners();
      } else {
        print('Fehler: App konnte nicht aus der Datenbank gelöscht werden');
      }
    } catch (error) {
      print('Fehler beim Löschen der App: $error');
      // Im Fehlerfall trotzdem lokal löschen
      _apps.removeWhere((app) => app.id == id);
      notifyListeners();
    }
  }

  // App aktualisieren
  Future<void> updateApp(VerkehrsunternehmenApp updatedApp) async {
    try {
      // Zuerst in der Datenbank aktualisieren
      final success = await _dbService.updateVerkehrsunternehmenApp(updatedApp);
      
      if (success) {
        // Wenn erfolgreich in der Datenbank, dann auch im lokalen Speicher
        final index = _apps.indexWhere((app) => app.id == updatedApp.id);
        if (index >= 0) {
          _apps[index] = updatedApp;
          notifyListeners();
        }
      } else {
        print('Fehler: App konnte nicht in der Datenbank aktualisiert werden');
      }
    } catch (error) {
      print('Fehler beim Aktualisieren der App: $error');
      // Im Fehlerfall trotzdem lokal aktualisieren
      final index = _apps.indexWhere((app) => app.id == updatedApp.id);
      if (index >= 0) {
        _apps[index] = updatedApp;
        notifyListeners();
      }
    }
  }

  // App nach ID finden
  VerkehrsunternehmenApp? findById(String id) {
    try {
      return _apps.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  // Apps nach Verkehrsunternehmen-ID filtern
  List<VerkehrsunternehmenApp> findByVerkehrsunternehmen(String verkehrsunternehmenId) {
    return _apps.where((app) => app.verkehrsunternehmenId == verkehrsunternehmenId).toList();
  }

  // Apps für ein bestimmtes Verkehrsunternehmen laden
  Future<void> loadAppsByVerkehrsunternehmen(String verkehrsunternehmenId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Daten aus der Datenbank abrufen
      final loadedApps = await _dbService.getAppsByVerkehrsunternehmenId(verkehrsunternehmenId);
      
      // Alle bestehenden Apps für dieses Unternehmen entfernen
      _apps.removeWhere((app) => app.verkehrsunternehmenId == verkehrsunternehmenId);
      
      // Neue Apps hinzufügen
      _apps.addAll(loadedApps);
      
    } catch (error) {
      print('Fehler beim Laden der Apps für Verkehrsunternehmen: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Für Demo-Zwecke: Beispieldaten hinzufügen
  void addDemoData() {
    if (_apps.isEmpty) {
      final demoApps = [
        // Apps für WSW (ID: 4)
        VerkehrsunternehmenApp(
          id: '1',
          name: 'WSW move App',
          beschreibung: 'Mobilitäts-App der WSW',
          verkehrsunternehmenId: '4',
        ),
        VerkehrsunternehmenApp(
          id: '2',
          name: 'WSW Ticket App',
          beschreibung: 'Ticket-App der WSW',
          verkehrsunternehmenId: '4',
        ),
        VerkehrsunternehmenApp(
          id: '3',
          name: 'HandyTicket Deutschland App',
          beschreibung: 'Überregionale Ticket-App',
          verkehrsunternehmenId: '4',
        ),
        VerkehrsunternehmenApp(
          id: '4',
          name: 'DeutschlandTicket App',
          beschreibung: 'App für das Deutschland-Ticket',
          verkehrsunternehmenId: '4',
        ),
        
        // Apps für DB (ID: 1)
        VerkehrsunternehmenApp(
          id: '5',
          name: 'DB Navigator',
          beschreibung: 'Die offizielle App der Deutschen Bahn',
          verkehrsunternehmenId: '1',
        ),
        VerkehrsunternehmenApp(
          id: '6',
          name: 'DB Streckenagent',
          beschreibung: 'Für Pendler und Vielfahrer',
          verkehrsunternehmenId: '1',
        ),
        
        // Apps für BVG (ID: 2)
        VerkehrsunternehmenApp(
          id: '7',
          name: 'BVG Fahrinfo',
          beschreibung: 'Die offizielle App der BVG',
          verkehrsunternehmenId: '2',
        ),
        VerkehrsunternehmenApp(
          id: '8',
          name: 'Jelbi',
          beschreibung: 'Multimodale Mobilitätsplattform der BVG',
          verkehrsunternehmenId: '2',
        ),
        
        // Apps für MVG (ID: 3)
        VerkehrsunternehmenApp(
          id: '9',
          name: 'MVG Fahrinfo',
          beschreibung: 'Die offizielle App der MVG',
          verkehrsunternehmenId: '3',
        ),
        VerkehrsunternehmenApp(
          id: '10',
          name: 'MVG more',
          beschreibung: 'Multimodale App der MVG',
          verkehrsunternehmenId: '3',
        ),
      ];
      
      // Demo-Daten zu lokaler Liste hinzufügen
      _apps = demoApps;
      notifyListeners();
      
      // Anschließend versuchen, die Demo-Daten in die Datenbank zu schreiben
      for (var app in demoApps) {
        _dbService.addVerkehrsunternehmenApp(app).catchError((error) {
          print('Fehler beim Hinzufügen von Demo-App-Daten zur Datenbank: $error');
        });
      }
    }
  }
}