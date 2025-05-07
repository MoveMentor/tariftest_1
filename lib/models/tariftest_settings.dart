// lib/models/tariftest_settings.dart
import 'package:flutter/foundation.dart';

class TariftestSettings with ChangeNotifier {
  String? verkehrsunternehmenId;
  String? appId;
  DateTime? selectedMonth;
  String? testerName;
  String? testfallId; // Neu: ID des ausgewählten Testfalls

  // Getter für ausgewählten Monat in formatierter Form
  String get formattedMonth {
    if (selectedMonth == null) return '';
    
    final months = [
      'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'
    ];
    
    return '${months[selectedMonth!.month - 1]} ${selectedMonth!.year}';
  }

  // Prüfen, ob alle erforderlichen Einstellungen vorhanden sind
  bool get isComplete {
    return verkehrsunternehmenId != null && 
           appId != null &&
           selectedMonth != null && 
           testerName != null && 
           testerName!.isNotEmpty;
  }

  // Prüfen, ob ein Testfall ausgewählt wurde
  bool get hasTestfall {
    return testfallId != null;
  }

  // Funktionen zum Aktualisieren der Einstellungen
  void setVerkehrsunternehmen(String? id) {
    verkehrsunternehmenId = id;
    // App zurücksetzen, wenn Verkehrsunternehmen geändert wird
    if (appId != null) {
      appId = null;
    }
    notifyListeners();
  }

  void setApp(String? id) {
    appId = id;
    notifyListeners();
  }

  void setSelectedMonth(DateTime? month) {
    if (month != null) {
      // Immer den ersten Tag des Monats speichern
      selectedMonth = DateTime(month.year, month.month, 1);
    } else {
      selectedMonth = null;
    }
    notifyListeners();
  }

  void setTesterName(String? name) {
    testerName = name;
    notifyListeners();
  }

  // Neuer Setter für Testfall
  void setTestfall(String? id) {
    testfallId = id;
    notifyListeners();
  }

  // Zurücksetzen aller Einstellungen
  void reset() {
    verkehrsunternehmenId = null;
    appId = null;
    selectedMonth = null;
    testerName = null;
    testfallId = null;
    notifyListeners();
  }
}