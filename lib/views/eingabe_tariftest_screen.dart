// lib/views/eingabe_tariftest_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verkehrsunternehmen_provider.dart';
import '../providers/verkehrsunternehmen_app_provider.dart';
import '../providers/tariftest_entry_provider.dart';
import '../models/tariftest_settings.dart';
import '../models/tariftest_entry.dart';
import 'tariftest_entry_screen.dart';

class EingabeTariftestScreen extends StatefulWidget {
  const EingabeTariftestScreen({Key? key}) : super(key: key);

  @override
  _EingabeTariftestScreenState createState() => _EingabeTariftestScreenState();
}

class _EingabeTariftestScreenState extends State<EingabeTariftestScreen> {
  // Controller für die Textfelder
  final _produktverantwortlicherController = TextEditingController();
  final _produktnummerController = TextEditingController();
  final _preisController = TextEditingController();
  final _raumnummerController = TextEditingController();
  final _klasseController = TextEditingController();
  final _besonderheitController = TextEditingController();
  final _anmerkungController = TextEditingController();
  
  // Form Key für Validierung
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Controller freigeben, wenn der Screen entfernt wird
    _produktverantwortlicherController.dispose();
    _produktnummerController.dispose();
    _preisController.dispose();
    _raumnummerController.dispose();
    _klasseController.dispose();
    _besonderheitController.dispose();
    _anmerkungController.dispose();
    super.dispose();
  }

  // Methode zum Starten der Prüfung und Übergang zum nächsten Testfall
  void _startePruefung() {
    if (_formKey.currentState!.validate()) {
      // Zugriff auf Provider
      final settings = Provider.of<TariftestSettings>(context, listen: false);
      final testfallProvider = Provider.of<TariftestEntryProvider>(context, listen: false);
      final unternehmenProvider = Provider.of<VerkehrsunternehmenProvider>(context, listen: false);
      final appProvider = Provider.of<VerkehrsunternehmenAppProvider>(context, listen: false);
      
      // Aktuellen Testfall abrufen
      final testfallId = settings.testfallId;
      final currentTestfall = testfallId != null ? testfallProvider.findById(testfallId) : null;
      
      if (currentTestfall == null) {
        // Kein Testfall ausgewählt - Benutzer informieren
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bitte wählen Sie zuerst einen Testfall aus'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      // Hier könntest du die komplexe Prüflogik implementieren
      // Vergleich der eingegebenen Daten mit dem aktuellen Testfall
      
      // Beispiel für zukünftige Prüflogik (als Platzhalter):
      bool pruefungErfolgreich = _pruefeTestfall(currentTestfall);
      
      // Beispiel für Datensammlung (für Debugging)
      final verkehrsunternehmenId = settings.verkehrsunternehmenId;
      final appId = settings.appId;
      
      final unternehmen = verkehrsunternehmenId != null 
          ? unternehmenProvider.findById(verkehrsunternehmenId) 
          : null;
      
      final app = appId != null
          ? appProvider.findById(appId)
          : null;
      
      final unternehmenName = unternehmen?.name ?? 'Nicht ausgewählt';
      final appName = app?.name ?? 'Nicht ausgewählt';
      final testfallName = currentTestfall.fallnummer;
      
      // Beispiel für Datensammlung
      final tariftestDaten = {
        'produktverantwortlicher': _produktverantwortlicherController.text,
        'verkehrsunternehmen': unternehmenName,
        'verkehrsunternehmenId': verkehrsunternehmenId,
        'app': appName,
        'appId': appId,
        'testfall': testfallName,
        'testfallId': testfallId,
        'testerName': settings.testerName,
        'testMonat': settings.formattedMonth,
        'produktnummer': _produktnummerController.text,
        'preis': _preisController.text,
        'raumnummer': _raumnummerController.text,
        'klasse': _klasseController.text,
        'besonderheit': _besonderheitController.text,
        'anmerkung': _anmerkungController.text,
      };
      
      print('Gesammelte Daten: $tariftestDaten');
      
      // Benachrichtigung über abgeschlossene Prüfung
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pruefungErfolgreich 
            ? 'Prüfung erfolgreich abgeschlossen!' 
            : 'Prüfung mit Abweichungen abgeschlossen'),
          backgroundColor: pruefungErfolgreich ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Nach kurzer Verzögerung zum nächsten Testfall wechseln
      Future.delayed(const Duration(seconds: 1), () {
        _wechsleZuNaechstemTestfall(currentTestfall.id);
      });
    }
  }

  // Hilfsmethode für die Prüflogik (Platzhalter für spätere Implementierung)
  bool _pruefeTestfall(TariftestEntry testfall) {
    // Hier würde die komplexe Prüflogik implementiert werden
    // Vergleich der eingegebenen Daten mit dem Testfall
    
    // Beispiel für eine einfache Prüfung (als Platzhalter)
    // In der echten Implementierung würdest du hier komplexere Vergleiche durchführen
    bool isPreisKorrekt = true;
    bool isRaumKorrekt = true;
    bool isKlasseKorrekt = true;
    
    // Einfaches Beispiel - in der Realität würdest du hier deine
    // komplexe Prüflogik implementieren
    return isPreisKorrekt && isRaumKorrekt && isKlasseKorrekt;
  }

  // Methode zum Wechseln zum nächsten Testfall
  void _wechsleZuNaechstemTestfall(String currentTestfallId) {
    final testfallProvider = Provider.of<TariftestEntryProvider>(context, listen: false);
    final settings = Provider.of<TariftestSettings>(context, listen: false);
    
    // Alle verfügbaren Testfälle abrufen
    final alleTestfaelle = testfallProvider.entries;
    
    if (alleTestfaelle.isEmpty) {
      return;
    }
    
    // Index des aktuellen Testfalls finden
    final currentIndex = alleTestfaelle.indexWhere((tf) => tf.id == currentTestfallId);
    
    // Wenn der aktuelle Testfall nicht gefunden wurde oder bereits der letzte ist
    if (currentIndex == -1 || currentIndex >= alleTestfaelle.length - 1) {
      // Entweder zum ersten Testfall zurückkehren oder bei dem letzten bleiben
      // Hier: Zum ersten zurückkehren, wenn bereits am Ende
      if (currentIndex >= alleTestfaelle.length - 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Letzter Testfall erreicht. Beginne von vorne.'),
            backgroundColor: Colors.blue,
          ),
        );
        // Zum ersten Testfall wechseln
        settings.setTestfall(alleTestfaelle[0].id);
      }
    } else {
      // Zum nächsten Testfall wechseln
      final nextTestfall = alleTestfaelle[currentIndex + 1];
      settings.setTestfall(nextTestfall.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nächster Testfall: ${nextTestfall.fallnummer}'),
          backgroundColor: Colors.blue,
        ),
      );
    }
    
    // Formular zurücksetzen für den neuen Testfall
    _resetForm();
  }

  // Hilfsmethode zum Zurücksetzen des Formulars
  void _resetForm() {
    _produktverantwortlicherController.clear();
    _produktnummerController.clear();
    _preisController.clear();
    _raumnummerController.clear();
    _klasseController.clear();
    _besonderheitController.clear();
    _anmerkungController.clear();
  }

  // Hilfsmethode zum Öffnen der Testfall-Liste
  void _navigateToTestfallList() {
    // Direkt zur TariftestEntriesScreen navigieren
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TariftestEntriesScreen(),
      ),
    );
    
    // Hinweis anzeigen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bitte wählen Sie einen Testfall aus der Liste'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Zugriff auf die Einstellungen und Provider
    final settings = Provider.of<TariftestSettings>(context);
    final unternehmenProvider = Provider.of<VerkehrsunternehmenProvider>(context);
    final appProvider = Provider.of<VerkehrsunternehmenAppProvider>(context);
    final testfallProvider = Provider.of<TariftestEntryProvider>(context);
    
    // Informationen zum ausgewählten Verkehrsunternehmen und App abrufen
    final selectedUnternehmen = settings.verkehrsunternehmenId != null
        ? unternehmenProvider.findById(settings.verkehrsunternehmenId!)
        : null;
    
    final selectedApp = settings.appId != null
        ? appProvider.findById(settings.appId!)
        : null;
    
    // Ausgewählten Testfall abrufen
    final selectedTestfall = settings.testfallId != null
        ? testfallProvider.findById(settings.testfallId!)
        : null;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariftest'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Überschrift
                const Text(
                  'Tariftest',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Ausgewählte Konfigurationsinformationen anzeigen
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.business, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Verkehrsunternehmen:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              selectedUnternehmen != null 
                              ? '${selectedUnternehmen.name} (${selectedUnternehmen.kuerzel})'
                              : 'Nicht ausgewählt',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone_android, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'App:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(selectedApp?.name ?? 'Nicht ausgewählt'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Testmonat:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(settings.formattedMonth.isNotEmpty 
                              ? settings.formattedMonth 
                              : 'Nicht ausgewählt'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Tester:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(settings.testerName ?? 'Nicht angegeben'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Testfall-Information mit schöner Darstellung
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ausgewählter Testfall',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: _navigateToTestfallList,
                            tooltip: 'Testfall auswählen',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (selectedTestfall != null) ...[
                        // Details des ausgewählten Testfalls
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Fallnummer: ${selectedTestfall.fallnummer}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedTestfall.typ == 'iOS'
                                          ? Colors.blue.shade100
                                          : Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      selectedTestfall.typ,
                                      style: TextStyle(
                                        color: selectedTestfall.typ == 'iOS'
                                            ? Colors.blue.shade800
                                            : Colors.green.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoBox(
                                      'Ebene',
                                      selectedTestfall.ebene,
                                      Icons.layers,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInfoBox(
                                      'Preisstufe',
                                      selectedTestfall.preisstufe,
                                      Icons.attach_money,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Ticketart anzeigen
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoBox(
                                      'Ticketart',
                                      selectedTestfall.ticketart,
                                      Icons.confirmation_number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoBox(
                                'Route',
                                '${selectedTestfall.startort} → ${selectedTestfall.zielort}',
                                Icons.route,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoBox(
                                      'Personenanzahl',
                                      '${selectedTestfall.personenanzahl} ${selectedTestfall.personenanzahl == 1 ? 'Person' : 'Personen'}',
                                      Icons.people,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildInfoBox(
                                      'Personentyp',
                                      selectedTestfall.istKind ? 'Kind' : 'Erwachsener',
                                      selectedTestfall.istKind ? Icons.child_care : Icons.person,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Kein Testfall ausgewählt
                        Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.assignment_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Kein Testfall ausgewählt',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _navigateToTestfallList,
                                icon: const Icon(Icons.add),
                                label: const Text('Testfall auswählen'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Eingabefelder (Pflichtfelder)
                _buildRequiredTextField(
                  controller: _produktverantwortlicherController,
                  label: 'Produktverantwortlicher',
                  icon: Icons.person,
                ),
                _buildRequiredTextField(
                  controller: _produktnummerController,
                  label: 'Produktnummer',
                  icon: Icons.numbers,
                ),
                _buildRequiredTextField(
                  controller: _preisController,
                  label: 'Preis',
                  icon: Icons.euro,
                  keyboardType: TextInputType.number,
                ),
                _buildRequiredTextField(
                  controller: _raumnummerController,
                  label: 'Raumnummer',
                  icon: Icons.room,
                ),
                _buildRequiredTextField(
                  controller: _klasseController,
                  label: 'Klasse',
                  icon: Icons.class_,
                ),
                
                // Optionale Eingabefelder
                _buildOptionalTextField(
                  controller: _besonderheitController,
                  label: 'Besonderheit (optional)',
                  icon: Icons.star,
                ),
                _buildOptionalTextField(
                  controller: _anmerkungController,
                  label: 'Anmerkung (optional)',
                  icon: Icons.note,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 24),
                
                // Button "Prüfung beginnen"
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _startePruefung,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Prüfung beginnen'),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hilfsmethode zur Erstellung einheitlicher Pflicht-Textfelder
  Widget _buildRequiredTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label *', // Sternchen für Pflichtfelder
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bitte $label eingeben';
          }
          return null;
        },
      ),
    );
  }

  // Hilfsmethode zur Erstellung einheitlicher optionaler Textfelder
  Widget _buildOptionalTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        // Kein Validator für optionale Felder
      ),
    );
  }
  
  // Hilfsmethode zur Erstellung von Informationsboxen
  Widget _buildInfoBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}