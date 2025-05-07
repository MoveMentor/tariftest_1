// lib/views/tariftest_entries_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tariftest_entry.dart';
import '../providers/tariftest_entry_provider.dart';
import '../models/tariftest_settings.dart';

class TariftestEntriesScreen extends StatefulWidget {
  const TariftestEntriesScreen({Key? key}) : super(key: key);

  @override
  _TariftestEntriesScreenState createState() => _TariftestEntriesScreenState();
}

class _TariftestEntriesScreenState extends State<TariftestEntriesScreen> {
  // Controller für die Textfelder
  final _fallnummerController = TextEditingController();
  final _startortController = TextEditingController();
  final _zielortController = TextEditingController();
  
  // Ausgewählte Dropdown-Werte
  String _selectedTyp = 'iOS';
  String _selectedSystemdienstleister = 'HanseCom';
  String _selectedEbene = 'Katalog-Kauf';
  String _selectedPreisstufe = 'Pst. A';
  String _selectedTicketArt = 'EinzelTicket'; // Neues Feld für Ticketart
  
  // Neue Werte für Personenanzahl und Typ
  int _personenanzahl = 1;
  bool _istKind = false;
  
  // Listen für Dropdown-Felder
  final List<String> _typOptions = ['iOS', 'Android'];
  final List<String> _systemdienstleisterOptions = ['HanseCom', 'Mentz', 'ICA', 'Digital H'];
  final List<String> _ebeneOptions = ['Katalog-Kauf', 'Routen-Kauf'];
  final List<String> _preisstufeOptions = ['Pst. A', 'Pst. B', 'Pst. C'];

  final _formKey = GlobalKey<FormState>();

  // Zum Suchen und Filtern
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Demo-Daten laden, wenn die Seite geladen wird
    Future.microtask(() {
      Provider.of<TariftestEntryProvider>(context, listen: false).addDemoData();
    });
  }

  @override
  void dispose() {
    _fallnummerController.dispose();
    _startortController.dispose();
    _zielortController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Dialog zum Hinzufügen eines neuen Eintrags
  void _showAddDialog() {
    // Controller zurücksetzen
    _fallnummerController.clear();
    _startortController.clear();
    _zielortController.clear();
    
    // Dropdown-Werte zurücksetzen
    _selectedTyp = 'iOS';
    _selectedSystemdienstleister = 'HanseCom';
    _selectedEbene = 'Katalog-Kauf';
    _selectedPreisstufe = 'Pst. A';
    
    // Personenanzahl und Typ zurücksetzen
    _personenanzahl = 1;
    _istKind = false;
    
    // Tickets aus Provider abrufen
    final ticketArten = Provider.of<TariftestEntryProvider>(context, listen: false).ticketArten;
    _selectedTicketArt = ticketArten[0]; // Standard: erste Ticketart auswählen

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Neuer Tariftest-Eintrag'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _fallnummerController,
                    decoration: const InputDecoration(labelText: 'Fallnummer'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte eine Fallnummer eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Typ
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Typ'),
                    value: _selectedTyp,
                    items: _typOptions.map((typ) {
                      return DropdownMenuItem<String>(
                        value: typ,
                        child: Text(typ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTyp = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Systemdienstleister
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Systemdienstleister'),
                    value: _selectedSystemdienstleister,
                    items: _systemdienstleisterOptions.map((dienstleister) {
                      return DropdownMenuItem<String>(
                        value: dienstleister,
                        child: Text(dienstleister),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSystemdienstleister = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Ebene
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Ebene'),
                    value: _selectedEbene,
                    items: _ebeneOptions.map((ebene) {
                      return DropdownMenuItem<String>(
                        value: ebene,
                        child: Text(ebene),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEbene = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Preisstufe
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Preisstufe'),
                    value: _selectedPreisstufe,
                    items: _preisstufeOptions.map((preisstufe) {
                      return DropdownMenuItem<String>(
                        value: preisstufe,
                        child: Text(preisstufe),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPreisstufe = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Ticketart
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Ticketart'),
                    value: _selectedTicketArt,
                    items: Provider.of<TariftestEntryProvider>(context, listen: false)
                        .ticketArten
                        .map((ticket) {
                      return DropdownMenuItem<String>(
                        value: ticket,
                        child: Text(ticket),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTicketArt = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte eine Ticketart auswählen';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Textfelder für Start- und Zielort
                  TextFormField(
                    controller: _startortController,
                    decoration: const InputDecoration(labelText: 'Startort'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte einen Startort eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _zielortController,
                    decoration: const InputDecoration(labelText: 'Zielort'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte einen Zielort eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Personenanzahl Auswahl
                  Row(
                    children: [
                      const Text('Personenanzahl:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      DropdownButton<int>(
                        value: _personenanzahl,
                        items: [1, 2, 3, 4, 5].map((anzahl) {
                          return DropdownMenuItem<int>(
                            value: anzahl,
                            child: Text('$anzahl'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _personenanzahl = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Checkbox für Personentyp
                  Row(
                    children: [
                      Checkbox(
                        value: _istKind,
                        onChanged: (value) {
                          setState(() {
                            _istKind = value!;
                          });
                        },
                      ),
                      const Text('Kind (ansonsten Erwachsener)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final provider = Provider.of<TariftestEntryProvider>(
                    context, 
                    listen: false
                  );
                  
                  final newEntry = TariftestEntry(
                    fallnummer: _fallnummerController.text,
                    typ: _selectedTyp,
                    systemdienstleister: _selectedSystemdienstleister,
                    ebene: _selectedEbene,
                    preisstufe: _selectedPreisstufe,
                    startort: _startortController.text,
                    zielort: _zielortController.text,
                    personenanzahl: _personenanzahl,
                    istKind: _istKind,
                    ticketart: _selectedTicketArt, // Kleinbuchstaben "art"
                  );
                  
                  provider.addEntry(newEntry);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog zum Bearbeiten eines bestehenden Eintrags
  void _showEditDialog(TariftestEntry entry) {
    // Controller mit bestehenden Daten vorausfüllen
    _fallnummerController.text = entry.fallnummer;
    _startortController.text = entry.startort;
    _zielortController.text = entry.zielort;
    
    // Dropdown-Werte setzen
    _selectedTyp = entry.typ;
    _selectedSystemdienstleister = entry.systemdienstleister;
    _selectedEbene = entry.ebene;
    _selectedPreisstufe = entry.preisstufe;
    _selectedTicketArt = entry.ticketart;
    
    // Personenwerte setzen
    _personenanzahl = entry.personenanzahl;
    _istKind = entry.istKind;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Tariftest "${entry.fallnummer}" bearbeiten'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _fallnummerController,
                    decoration: const InputDecoration(labelText: 'Fallnummer'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte eine Fallnummer eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Typ
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Typ'),
                    value: _selectedTyp,
                    items: _typOptions.map((typ) {
                      return DropdownMenuItem<String>(
                        value: typ,
                        child: Text(typ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTyp = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Systemdienstleister
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Systemdienstleister'),
                    value: _selectedSystemdienstleister,
                    items: _systemdienstleisterOptions.map((dienstleister) {
                      return DropdownMenuItem<String>(
                        value: dienstleister,
                        child: Text(dienstleister),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSystemdienstleister = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Ebene
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Ebene'),
                    value: _selectedEbene,
                    items: _ebeneOptions.map((ebene) {
                      return DropdownMenuItem<String>(
                        value: ebene,
                        child: Text(ebene),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEbene = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Preisstufe
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Preisstufe'),
                    value: _selectedPreisstufe,
                    items: _preisstufeOptions.map((preisstufe) {
                      return DropdownMenuItem<String>(
                        value: preisstufe,
                        child: Text(preisstufe),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPreisstufe = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dropdown für Ticketart
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Ticketart'),
                    value: _selectedTicketArt,
                    items: Provider.of<TariftestEntryProvider>(context, listen: false)
                        .ticketArten
                        .map((ticket) {
                      return DropdownMenuItem<String>(
                        value: ticket,
                        child: Text(ticket),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTicketArt = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte eine Ticketart auswählen';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Textfelder für Start- und Zielort
                  TextFormField(
                    controller: _startortController,
                    decoration: const InputDecoration(labelText: 'Startort'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte einen Startort eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _zielortController,
                    decoration: const InputDecoration(labelText: 'Zielort'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte einen Zielort eingeben';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Personenanzahl Auswahl
                  Row(
                    children: [
                      const Text('Personenanzahl:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16),
                      DropdownButton<int>(
                        value: _personenanzahl,
                        items: [1, 2, 3, 4, 5].map((anzahl) {
                          return DropdownMenuItem<int>(
                            value: anzahl,
                            child: Text('$anzahl'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _personenanzahl = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Checkbox für Personentyp
                  Row(
                    children: [
                      Checkbox(
                        value: _istKind,
                        onChanged: (value) {
                          setState(() {
                            _istKind = value!;
                          });
                        },
                      ),
                      const Text('Kind (ansonsten Erwachsener)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final provider = Provider.of<TariftestEntryProvider>(
                    context, 
                    listen: false
                  );
                  
                  // Aktualisierter Eintrag mit der bestehenden ID
                  final updatedEntry = TariftestEntry(
                    id: entry.id, // Bestehende ID beibehalten!
                    fallnummer: _fallnummerController.text,
                    typ: _selectedTyp,
                    systemdienstleister: _selectedSystemdienstleister,
                    ebene: _selectedEbene,
                    preisstufe: _selectedPreisstufe,
                    startort: _startortController.text,
                    zielort: _zielortController.text,
                    personenanzahl: _personenanzahl,
                    istKind: _istKind,
                    ticketart: _selectedTicketArt,
                  );
                  
                  // Eintrag aktualisieren
                  provider.updateEntry(updatedEntry);
                  Navigator.of(ctx).pop();
                  
                  // Erfolgsbenachrichtigung anzeigen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Eintrag "${entry.fallnummer}" wurde aktualisiert'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialogfenster zur Bestätigung des Löschens
  void _confirmDelete(TariftestEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tariftest-Eintrag löschen'),
        content: Text(
          'Möchten Sie den Tariftest-Eintrag "${entry.fallnummer}" wirklich löschen?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TariftestEntryProvider>(
                context, 
                listen: false
              ).deleteEntry(entry.id);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }
  
  // Hilfsmethode zur Anzeige von Detailzeilen
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariftest-Einträge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Neuen Eintrag hinzufügen',
          ),
        ],
      ),
      body: Column(
        children: [
          // Suchleiste
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Suchen',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Liste der Einträge
          Expanded(
            child: Consumer<TariftestEntryProvider>(
              builder: (ctx, provider, child) {
                final entries = provider.entries;
                
                // Filtern der Einträge nach Suchbegriff
                final filteredEntries = _searchQuery.isEmpty
                    ? entries
                    : entries.where((entry) {
                        final lowerQuery = _searchQuery.toLowerCase();
                        return entry.fallnummer.toLowerCase().contains(lowerQuery) ||
                               entry.startort.toLowerCase().contains(lowerQuery) ||
                               entry.zielort.toLowerCase().contains(lowerQuery);
                      }).toList();
                
                if (filteredEntries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Keine Tariftest-Einträge vorhanden'
                              : 'Keine Einträge für "$_searchQuery" gefunden',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _showAddDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Eintrag hinzufügen'),
                          ),
                        ]
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: filteredEntries.length,
                  itemBuilder: (ctx, index) {
                    final entry = filteredEntries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'Fallnummer: ${entry.fallnummer}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${entry.startort} → ${entry.zielort}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Typ', entry.typ),
                                _buildDetailRow('Systemdienstleister', entry.systemdienstleister),
                                _buildDetailRow('Ebene', entry.ebene),
                                _buildDetailRow('Preisstufe', entry.preisstufe),
                                _buildDetailRow('Ticketart', entry.ticketart),
                                _buildDetailRow('Personenanzahl', entry.personenanzahl.toString()),
                                _buildDetailRow('Personentyp', entry.istKind ? 'Kind' : 'Erwachsener'),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Button, der diesen Testfall für die Eingabeseite auswählt
                                    TextButton.icon(
                                      icon: const Icon(Icons.check_circle, color: Colors.green),
                                      label: const Text('Als Testfall auswählen'),
                                      onPressed: () {
                                        // Testfall in den Einstellungen speichern
                                        Provider.of<TariftestSettings>(context, listen: false)
                                          .setTestfall(entry.id);
                                        
                                        // Feedback geben
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Testfall "${entry.fallnummer}" ausgewählt'),
                                            backgroundColor: Colors.green,
                                            action: SnackBarAction(
                                              label: 'Zur Eingabeseite',
                                              onPressed: () {
                                                // Zur Eingabeseite navigieren
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        TextButton.icon(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          label: const Text('Bearbeiten'),
                                          onPressed: () {
                                            // Bearbeitungsdialog mit vorausgefüllten Daten öffnen
                                            _showEditDialog(entry);
                                          },
                                        ),
                                        const SizedBox(width: 16),
                                        TextButton.icon(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          label: const Text('Löschen'),
                                          onPressed: () => _confirmDelete(entry),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
        tooltip: 'Neuen Eintrag hinzufügen',
      ),
    );
  }
}