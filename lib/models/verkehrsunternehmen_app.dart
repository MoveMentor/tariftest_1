// lib/models/verkehrsunternehmen_app.dart
import 'dart:math';

class VerkehrsunternehmenApp {
  final String id;
  final String name;
  final String beschreibung;
  final String verkehrsunternehmenId;
  final String? appStoreLink;
  final String? playStoreLink;
  final bool? istKartenbasiert;
  final bool? hatRoutensuche;
  final String? bemerkungen;

  // Einfache ID-Generierung ohne UUID-Abhängigkeit
  static String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        16, 
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  // Konstruktor mit benannten Parametern
  VerkehrsunternehmenApp({
    String? id,
    required this.name,
    required this.beschreibung,
    required this.verkehrsunternehmenId,
    this.appStoreLink,
    this.playStoreLink,
    this.istKartenbasiert,
    this.hatRoutensuche,
    this.bemerkungen,
  }) : id = id ?? _generateId(); // Automatische ID-Generierung, wenn keine angegeben

  // Kopier-Konstruktor mit Änderungen
  VerkehrsunternehmenApp copyWith({
    String? id,
    String? name,
    String? beschreibung,
    String? verkehrsunternehmenId,
    String? appStoreLink,
    String? playStoreLink,
    bool? istKartenbasiert,
    bool? hatRoutensuche,
    String? bemerkungen,
  }) {
    return VerkehrsunternehmenApp(
      id: id ?? this.id,
      name: name ?? this.name,
      beschreibung: beschreibung ?? this.beschreibung,
      verkehrsunternehmenId: verkehrsunternehmenId ?? this.verkehrsunternehmenId,
      appStoreLink: appStoreLink ?? this.appStoreLink,
      playStoreLink: playStoreLink ?? this.playStoreLink,
      istKartenbasiert: istKartenbasiert ?? this.istKartenbasiert,
      hatRoutensuche: hatRoutensuche ?? this.hatRoutensuche,
      bemerkungen: bemerkungen ?? this.bemerkungen,
    );
  }

  // Für JSON-Serialisierung/Deserialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'beschreibung': beschreibung,
      'verkehrsunternehmenId': verkehrsunternehmenId,
      'appStoreLink': appStoreLink,
      'playStoreLink': playStoreLink,
      'istKartenbasiert': istKartenbasiert,
      'hatRoutensuche': hatRoutensuche,
      'bemerkungen': bemerkungen,
    };
  }

  // Factory-Konstruktor für JSON-Deserialisierung
  factory VerkehrsunternehmenApp.fromJson(Map<String, dynamic> json) {
    return VerkehrsunternehmenApp(
      id: json['id'],
      name: json['name'],
      beschreibung: json['beschreibung'],
      verkehrsunternehmenId: json['verkehrsunternehmenId'],
      appStoreLink: json['appStoreLink'],
      playStoreLink: json['playStoreLink'],
      istKartenbasiert: json['istKartenbasiert'],
      hatRoutensuche: json['hatRoutensuche'],
      bemerkungen: json['bemerkungen'],
    );
  }

  @override
  String toString() {
    return 'VerkehrsunternehmenApp{id: $id, name: $name, verkehrsunternehmenId: $verkehrsunternehmenId}';
  }
}