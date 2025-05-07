// lib/models/tariftest_entry.dart
import 'dart:math';

class TariftestEntry {
  final String id;
  final String fallnummer;
  final String typ; // iOS, Android, etc.
  final String systemdienstleister; // HanseCom, Mentz, ICA, Digital H, etc.
  final String ebene; // Katalog-Kauf, Routen-Kauf, etc.
  final String preisstufe; // Pst. A, Pst. B, etc.
  final String startort;
  final String zielort;
  final int personenanzahl;
  final bool istKind;
  final String ticketart; // EinzelTicket, 4er-Ticket, etc.
  final DateTime? timestamp;
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

  // Konstruktor mit benannten Parametern für bessere Lesbarkeit
  TariftestEntry({
    String? id,
    required this.fallnummer,
    required this.typ,
    required this.systemdienstleister,
    required this.ebene,
    required this.preisstufe,
    required this.startort,
    required this.zielort,
    required this.personenanzahl,
    required this.istKind,
    required this.ticketart,
    this.timestamp,
    this.bemerkungen,
  }) : id = id ?? _generateId(); // Automatische ID-Generierung, wenn keine angegeben

  // Kopier-Konstruktor mit Änderungen
  TariftestEntry copyWith({
    String? id,
    String? fallnummer,
    String? typ,
    String? systemdienstleister,
    String? ebene,
    String? preisstufe,
    String? startort,
    String? zielort,
    int? personenanzahl,
    bool? istKind,
    String? ticketart,
    DateTime? timestamp,
    String? bemerkungen,
  }) {
    return TariftestEntry(
      id: id ?? this.id,
      fallnummer: fallnummer ?? this.fallnummer,
      typ: typ ?? this.typ,
      systemdienstleister: systemdienstleister ?? this.systemdienstleister,
      ebene: ebene ?? this.ebene,
      preisstufe: preisstufe ?? this.preisstufe,
      startort: startort ?? this.startort,
      zielort: zielort ?? this.zielort,
      personenanzahl: personenanzahl ?? this.personenanzahl,
      istKind: istKind ?? this.istKind,
      ticketart: ticketart ?? this.ticketart,
      timestamp: timestamp ?? this.timestamp,
      bemerkungen: bemerkungen ?? this.bemerkungen,
    );
  }

  // Für JSON-Serialisierung/Deserialisierung
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fallnummer': fallnummer,
      'typ': typ,
      'systemdienstleister': systemdienstleister,
      'ebene': ebene,
      'preisstufe': preisstufe,
      'startort': startort,
      'zielort': zielort,
      'personenanzahl': personenanzahl,
      'istKind': istKind,
      'ticketart': ticketart,
      'timestamp': timestamp?.toIso8601String(),
      'bemerkungen': bemerkungen,
    };
  }

  // Factory-Konstruktor für JSON-Deserialisierung
  factory TariftestEntry.fromJson(Map<String, dynamic> json) {
    return TariftestEntry(
      id: json['id'],
      fallnummer: json['fallnummer'],
      typ: json['typ'],
      systemdienstleister: json['systemdienstleister'],
      ebene: json['ebene'],
      preisstufe: json['preisstufe'],
      startort: json['startort'],
      zielort: json['zielort'],
      personenanzahl: json['personenanzahl'],
      istKind: json['istKind'],
      ticketart: json['ticketart'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
      bemerkungen: json['bemerkungen'],
    );
  }

  @override
  String toString() {
    return 'TariftestEntry{id: $id, fallnummer: $fallnummer, typ: $typ, ticketart: $ticketart}';
  }
}