// lib/services/database_service.dart
import 'package:mysql1/mysql1.dart';
import '../models/tariftest_entry.dart';
import '../models/verkehrsunternehmen.dart';
import '../models/verkehrsunternehmen_app.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() => _instance;
  
  DatabaseService._internal();

 Future<MySqlConnection> getConnection() async {
  try {
    final settings = ConnectionSettings(
      host: 'web248.dogado.net',
      port: 3307,
      user: 'h706206_testnutzer',
      password: 'H5pdofc1!',
      db: 'h706206_tariftest_01',
      // SSL-Option entfernt
      timeout: const Duration(seconds: 15) // Timeout erhöht
    );
    
    return await MySqlConnection.connect(settings);
  } catch (e) {
    print('Fehler bei Datenbankverbindung: $e');
    throw e;
  }
}

  // Methoden für TariftestEntry

  Future<List<TariftestEntry>> getAllTariftestEntries() async {
    final conn = await getConnection();
    List<TariftestEntry> entries = [];
    
    try {
      var results = await conn.query('SELECT * FROM tariftest_entries');
      
      for (var row in results) {
        entries.add(
          TariftestEntry(
            id: row['id'].toString(),
            fallnummer: row['fallnummer'],
            typ: row['typ'],
            systemdienstleister: row['systemdienstleister'],
            ebene: row['ebene'],
            preisstufe: row['preisstufe'],
            startort: row['startort'],
            zielort: row['zielort'],
            personenanzahl: row['personenanzahl'],
            istKind: row['ist_kind'] == 1, // Boolean aus Integer konvertieren
            ticketart: row['ticketart'],
            timestamp: row['timestamp'] != null ? DateTime.parse(row['timestamp']) : null,
            bemerkungen: row['bemerkungen'],
          )
        );
      }
    } catch (e) {
      print('Fehler beim Abrufen der Tariftest-Einträge: $e');
    } finally {
      await conn.close();
    }
    
    return entries;
  }

  Future<TariftestEntry?> getTariftestEntryById(String id) async {
    final conn = await getConnection();
    TariftestEntry? entry;
    
    try {
      var results = await conn.query(
        'SELECT * FROM tariftest_entries WHERE id = ?',
        [id]
      );
      
      if (results.isNotEmpty) {
        var row = results.first;
        entry = TariftestEntry(
          id: row['id'].toString(),
          fallnummer: row['fallnummer'],
          typ: row['typ'],
          systemdienstleister: row['systemdienstleister'],
          ebene: row['ebene'],
          preisstufe: row['preisstufe'],
          startort: row['startort'],
          zielort: row['zielort'],
          personenanzahl: row['personenanzahl'],
          istKind: row['ist_kind'] == 1,
          ticketart: row['ticketart'],
          timestamp: row['timestamp'] != null ? DateTime.parse(row['timestamp']) : null,
          bemerkungen: row['bemerkungen'],
        );
      }
    } catch (e) {
      print('Fehler beim Abrufen des Tariftest-Eintrags: $e');
    } finally {
      await conn.close();
    }
    
    return entry;
  }

  Future<bool> addTariftestEntry(TariftestEntry entry) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'INSERT INTO tariftest_entries (id, fallnummer, typ, systemdienstleister, ebene, preisstufe, startort, zielort, personenanzahl, ist_kind, ticketart, timestamp, bemerkungen) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          entry.id,
          entry.fallnummer,
          entry.typ,
          entry.systemdienstleister,
          entry.ebene,
          entry.preisstufe,
          entry.startort,
          entry.zielort,
          entry.personenanzahl,
          entry.istKind ? 1 : 0,
          entry.ticketart,
          entry.timestamp?.toIso8601String(),
          entry.bemerkungen,
        ]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Hinzufügen des Tariftest-Eintrags: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  Future<bool> updateTariftestEntry(TariftestEntry entry) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'UPDATE tariftest_entries SET fallnummer = ?, typ = ?, systemdienstleister = ?, ebene = ?, preisstufe = ?, startort = ?, zielort = ?, personenanzahl = ?, ist_kind = ?, ticketart = ?, timestamp = ?, bemerkungen = ? WHERE id = ?',
        [
          entry.fallnummer,
          entry.typ,
          entry.systemdienstleister,
          entry.ebene,
          entry.preisstufe,
          entry.startort,
          entry.zielort,
          entry.personenanzahl,
          entry.istKind ? 1 : 0,
          entry.ticketart,
          entry.timestamp?.toIso8601String(),
          entry.bemerkungen,
          entry.id,
        ]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Aktualisieren des Tariftest-Eintrags: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  Future<bool> deleteTariftestEntry(String id) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'DELETE FROM tariftest_entries WHERE id = ?',
        [id]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Löschen des Tariftest-Eintrags: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  // Methoden für Verkehrsunternehmen

  Future<List<Verkehrsunternehmen>> getAllVerkehrsunternehmen() async {
    final conn = await getConnection();
    List<Verkehrsunternehmen> unternehmen = [];
    
    try {
      var results = await conn.query('SELECT * FROM verkehrsunternehmen');
      
      for (var row in results) {
        unternehmen.add(
          Verkehrsunternehmen(
            id: row['id'].toString(),
            name: row['name'],
            kuerzel: row['kuerzel'],
            kontakt: row['kontakt'],
            adresse: row['adresse'],
            website: row['website'],
            bemerkungen: row['bemerkungen'],
          )
        );
      }
    } catch (e) {
      print('Fehler beim Abrufen der Verkehrsunternehmen: $e');
    } finally {
      await conn.close();
    }
    
    return unternehmen;
  }

  Future<bool> addVerkehrsunternehmen(Verkehrsunternehmen unternehmen) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'INSERT INTO verkehrsunternehmen (id, name, kuerzel, kontakt, adresse, website, bemerkungen) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          unternehmen.id,
          unternehmen.name,
          unternehmen.kuerzel,
          unternehmen.kontakt,
          unternehmen.adresse,
          unternehmen.website,
          unternehmen.bemerkungen,
        ]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Hinzufügen des Verkehrsunternehmens: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  Future<bool> updateVerkehrsunternehmen(Verkehrsunternehmen unternehmen) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'UPDATE verkehrsunternehmen SET name = ?, kuerzel = ?, kontakt = ?, adresse = ?, website = ?, bemerkungen = ? WHERE id = ?',
        [
          unternehmen.name,
          unternehmen.kuerzel,
          unternehmen.kontakt,
          unternehmen.adresse,
          unternehmen.website,
          unternehmen.bemerkungen,
          unternehmen.id,
        ]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Aktualisieren des Verkehrsunternehmens: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  Future<bool> deleteVerkehrsunternehmen(String id) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'DELETE FROM verkehrsunternehmen WHERE id = ?',
        [id]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Löschen des Verkehrsunternehmens: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  // Methoden für VerkehrsunternehmenApp

  Future<List<VerkehrsunternehmenApp>> getAllVerkehrsunternehmenApps() async {
    final conn = await getConnection();
    List<VerkehrsunternehmenApp> apps = [];
    
    try {
      var results = await conn.query('SELECT * FROM verkehrsunternehmen_apps');
      
      for (var row in results) {
        apps.add(
          VerkehrsunternehmenApp(
            id: row['id'].toString(),
            name: row['name'],
            beschreibung: row['beschreibung'],
            verkehrsunternehmenId: row['verkehrsunternehmen_id'],
            appStoreLink: row['app_store_link'],
            playStoreLink: row['play_store_link'],
            istKartenbasiert: row['ist_kartenbasiert'] == 1,
            hatRoutensuche: row['hat_routensuche'] == 1,
            bemerkungen: row['bemerkungen'],
          )
        );
      }
    } catch (e) {
      print('Fehler beim Abrufen der Verkehrsunternehmen-Apps: $e');
    } finally {
      await conn.close();
    }
    
    return apps;
  }

  Future<List<VerkehrsunternehmenApp>> getAppsByVerkehrsunternehmenId(String verkehrsunternehmenId) async {
    final conn = await getConnection();
    List<VerkehrsunternehmenApp> apps = [];
    
    try {
      var results = await conn.query(
        'SELECT * FROM verkehrsunternehmen_apps WHERE verkehrsunternehmen_id = ?',
        [verkehrsunternehmenId]
      );
      
      for (var row in results) {
        apps.add(
          VerkehrsunternehmenApp(
            id: row['id'].toString(),
            name: row['name'],
            beschreibung: row['beschreibung'],
            verkehrsunternehmenId: row['verkehrsunternehmen_id'],
            appStoreLink: row['app_store_link'],
            playStoreLink: row['play_store_link'],
            istKartenbasiert: row['ist_kartenbasiert'] == 1,
            hatRoutensuche: row['hat_routensuche'] == 1,
            bemerkungen: row['bemerkungen'],
          )
        );
      }
    } catch (e) {
      print('Fehler beim Abrufen der Verkehrsunternehmen-Apps: $e');
    } finally {
      await conn.close();
    }
    
    return apps;
  }

  Future<bool> addVerkehrsunternehmenApp(VerkehrsunternehmenApp app) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'INSERT INTO verkehrsunternehmen_apps (id, name, beschreibung, verkehrsunternehmen_id, app_store_link, play_store_link, ist_kartenbasiert, hat_routensuche, bemerkungen) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          app.id,
          app.name,
          app.beschreibung,
          app.verkehrsunternehmenId,
          app.appStoreLink,
          app.playStoreLink,
          app.istKartenbasiert != null ? (app.istKartenbasiert! ? 1 : 0) : null,
          app.hatRoutensuche != null ? (app.hatRoutensuche! ? 1 : 0) : null,
          app.bemerkungen,
        ]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Hinzufügen der Verkehrsunternehmen-App: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  Future<bool> updateVerkehrsunternehmenApp(VerkehrsunternehmenApp app) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'UPDATE verkehrsunternehmen_apps SET name = ?, beschreibung = ?, verkehrsunternehmen_id = ?, app_store_link = ?, play_store_link = ?, ist_kartenbasiert = ?, hat_routensuche = ?, bemerkungen = ? WHERE id = ?',
        [
          app.name,
          app.beschreibung,
          app.verkehrsunternehmenId,
          app.appStoreLink,
          app.playStoreLink,
          app.istKartenbasiert != null ? (app.istKartenbasiert! ? 1 : 0) : null,
          app.hatRoutensuche != null ? (app.hatRoutensuche! ? 1 : 0) : null,
          app.bemerkungen,
          app.id,
        ]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Aktualisieren der Verkehrsunternehmen-App: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  Future<bool> deleteVerkehrsunternehmenApp(String id) async {
    final conn = await getConnection();
    bool success = false;
    
    try {
      var result = await conn.query(
        'DELETE FROM verkehrsunternehmen_apps WHERE id = ?',
        [id]
      );
      
      success = result.affectedRows! > 0;
    } catch (e) {
      print('Fehler beim Löschen der Verkehrsunternehmen-App: $e');
    } finally {
      await conn.close();
    }
    
    return success;
  }

  // Methode zum Testen der Datenbankverbindung
  Future<bool> testConnection() async {
    try {
      final conn = await getConnection();
      await conn.query('SELECT 1');
      await conn.close();
      return true;
    } catch (e) {
      print('Fehler beim Testen der Datenbankverbindung: $e');
      return false;
    }
  }
}