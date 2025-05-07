// lib/views/verkehrsunternehmen_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verkehrsunternehmen.dart';
import '../providers/verkehrsunternehmen_provider.dart';

class VerkehrsunternehmenScreen extends StatefulWidget {
  const VerkehrsunternehmenScreen({Key? key}) : super(key: key);

  @override
  _VerkehrsunternehmenScreenState createState() => _VerkehrsunternehmenScreenState();
}

class _VerkehrsunternehmenScreenState extends State<VerkehrsunternehmenScreen> {
  final _nameController = TextEditingController();
  final _kuerzelController = TextEditingController();
  final _kontaktController = TextEditingController();
  final _adresseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Demo-Daten laden, wenn die Seite geladen wird
    Future.microtask(() {
      Provider.of<VerkehrsunternehmenProvider>(context, listen: false).addDemoData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kuerzelController.dispose();
    _kontaktController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  // Dialogfenster zum Hinzufügen eines neuen Unternehmens
  void _showAddDialog() {
    // Controller zurücksetzen
    _nameController.clear();
    _kuerzelController.clear();
    _kontaktController.clear();
    _adresseController.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Neues Verkehrsunternehmen'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte einen Namen eingeben';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _kuerzelController,
                  decoration: const InputDecoration(labelText: 'Kürzel (optional)'),
                ),
                TextFormField(
                  controller: _kontaktController,
                  decoration: const InputDecoration(labelText: 'Kontakt (optional)'),
                ),
                TextFormField(
                  controller: _adresseController,
                  decoration: const InputDecoration(labelText: 'Adresse (optional)'),
                  maxLines: 2,
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
                final provider = Provider.of<VerkehrsunternehmenProvider>(
                  context, 
                  listen: false
                );
                
                // Direkten Konstruktor verwenden statt der nicht existierenden create-Methode
                final newUnternehmen = Verkehrsunternehmen(
                  name: _nameController.text,
                  kuerzel: _kuerzelController.text.isEmpty 
                    ? "" // Leerer String statt null, da kuerzel nicht nullable ist
                    : _kuerzelController.text,
                  kontakt: _kontaktController.text.isEmpty 
                    ? "" // Leerer String statt null, da kontakt nicht nullable ist
                    : _kontaktController.text,
                  adresse: _adresseController.text.isEmpty 
                    ? "" // Leerer String statt null, da adresse nicht nullable ist
                    : _adresseController.text,
                );
                
                provider.addUnternehmen(newUnternehmen);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  // Dialogfenster zur Bestätigung des Löschens
  void _confirmDelete(Verkehrsunternehmen unternehmen) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verkehrsunternehmen löschen'),
        content: Text(
          'Möchten Sie das Verkehrsunternehmen "${unternehmen.name}" wirklich löschen?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<VerkehrsunternehmenProvider>(
                context, 
                listen: false
              ).deleteUnternehmen(unternehmen.id);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verkehrsunternehmen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDialog,
            tooltip: 'Neues Unternehmen hinzufügen',
          ),
        ],
      ),
      body: Consumer<VerkehrsunternehmenProvider>(
        builder: (ctx, provider, child) {
          final unternehmen = provider.unternehmen;
          
          if (unternehmen.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keine Verkehrsunternehmen vorhanden',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Unternehmen hinzufügen'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: unternehmen.length,
            itemBuilder: (ctx, index) {
              final unternehmen = provider.unternehmen[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          unternehmen.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Kürzel wird jetzt immer angezeigt, da es nicht nullable ist
                      // Wenn das Kürzel leer sein kann, prüfen wir auf leeren String
                      if (unternehmen.kuerzel.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            unternehmen.kuerzel,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wir prüfen auf leere Strings statt auf null
                      if (unternehmen.kontakt.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('Kontakt: ${unternehmen.kontakt}'),
                        ),
                      if (unternehmen.adresse.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text('Adresse: ${unternehmen.adresse}'),
                        ),
                    ],
                  ),
                  isThreeLine: unternehmen.kontakt.isNotEmpty && unternehmen.adresse.isNotEmpty,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(unternehmen),
                    tooltip: 'Löschen',
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
        tooltip: 'Neues Unternehmen hinzufügen',
      ),
    );
  }
}