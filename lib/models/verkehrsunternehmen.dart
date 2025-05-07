// lib/models/verkehrsunternehmen.dart
import 'dart:math';

class Verkehrsunternehmen {
  final String id;
  final String name;
  final String kuerzel;
  final String kontakt;
  final String adresse;
  final String? website;
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
  Verkehrsunternehmen({
    String? id,
    required this.name,
    required this.kuerzel,
    required this.kontakt,
    required this.adresse,
    this.website,
    this.bemerkungen,
  }) : id = id ?? _generateId(); // Automatische ID-Generierung, wenn keine angegeben

  // Kopier-Konstruktor mit Änderungen
  Verkehrsunternehmen copyWith({
    String? id,
    String? name,
    String? kuerzel,
    String? kontakt,
    String? adresse,
    String? website,
    String? bemerkungen,
  }) {
    return Verkehrsunternehmen(
      id: id ?? this.id,
      name: name ?? this.name,
      kuerzel: kuerzel ?? this.kuerzel,
      kontakt: kontakt ?? this.kontakt,
      adresse: adresse ?? this.adresse,
      website: website ?? this.website,
      bemerkungen: bemerkungen ?? this.bemerkungen,
    );
  }

  // Für JSON-Serialisierung/Deserialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kuerzel': kuerzel,
      'kontakt': kontakt,
      'adresse': adresse,
      'website': website,
      'bemerkungen': bemerkungen,
    };
  }

  // Factory-Konstruktor für JSON-Deserialisierung
  factory Verkehrsunternehmen.fromJson(Map<String, dynamic> json) {
    return Verkehrsunternehmen(
      id: json['id'],
      name: json['name'],
      kuerzel: json['kuerzel'],
      kontakt: json['kontakt'],
      adresse: json['adresse'],
      website: json['website'],
      bemerkungen: json['bemerkungen'],
    );
  }

  @override
  String toString() {
    return 'Verkehrsunternehmen{id: $id, name: $name, kuerzel: $kuerzel}';
  }
}