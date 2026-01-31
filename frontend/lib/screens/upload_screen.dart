import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  final int experimentId;

  const UploadScreen({Key? key, required this.experimentId}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? _fileBytes;
  String? _fileName;

  final _typeController = TextEditingController();
  final _unitController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ApiService api = ApiService();

  Future<void> _pickFile() async {
    // On utilise FilePicker pour choisir le fichier
    final result = await FilePicker.platform.pickFiles(
      withData: true, // Obligatoire pour Flutter Web
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileBytes = result.files.first.bytes;
        _fileName = result.files.first.name;
      });
    }
  }

  Future<void> _submit() async {
    if (_fileBytes == null || _fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner un fichier")),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      await api.uploadDonnee(
        experimentId: widget.experimentId,
        fileBytes: _fileBytes!,
        fileName: _fileName!,
        dataType: _typeController.text,
        unit: _unitController.text.isEmpty ? null : _unitController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      showSuccessSnackBar(
        context: context,
        message: "Donnée uploadée avec succès",
        onContinue: () {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter une donnée")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text("Choisir un fichier"),
              ),
              if (_fileName != null) Text("Fichier sélectionné : $_fileName"),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: "Type de donnée *",
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: "Unité (Gy, mGy, cGy)",
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Uploader")),
            ],
          ),
        ),
      ),
    );
  }
}
