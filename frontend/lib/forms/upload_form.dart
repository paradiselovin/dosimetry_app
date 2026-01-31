import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';

class UploadForm extends StatefulWidget {
  final int experimentId;
  final VoidCallback onSuccess;

  const UploadForm({
    Key? key,
    required this.experimentId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormState>();

  Uint8List? _fileBytes;
  String? _fileName;

  final _typeController = TextEditingController();
  final _unitController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ApiService api = ApiService();
  bool _isSubmitting = false;

  // ---------------- Méthodes à l'intérieur de la classe ----------------
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);

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

    setState(() => _isSubmitting = true);

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

      widget.onSuccess(); // 🔥 wizard passe à l’étape suivante
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  // ---------------- Build UI ----------------
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: const Text("Choisir un fichier"),
          ),
          if (_fileName != null) Text("Fichier sélectionné : $_fileName"),
          TextFormField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: "Type de donnée *"),
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : const Text("Uploader"),
          ),
        ],
      ),
    );
  }
}
