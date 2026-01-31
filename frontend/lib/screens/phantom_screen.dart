import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import 'detector_screen.dart';

class PhantomScreen extends StatefulWidget {
  final int experimentId;

  const PhantomScreen({Key? key, required this.experimentId}) : super(key: key);

  @override
  State<PhantomScreen> createState() => _PhantomScreenState();
}

class _PhantomScreenState extends State<PhantomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _materialController = TextEditingController();

  final ApiService api = ApiService();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await api.createPhantom({
      "name": _nameController.text,
      "phantom_type": _typeController.text,
      "dimensions": _dimensionsController.text,
      "material": _materialController.text,
    });

    if (!mounted) return;

    if (result["success"]) {
      final phantomId = result["data"]["phantom_id"];

      await api.addPhantomToExperience(widget.experimentId, phantomId);

      showSuccessSnackBar(
        context: context,
        message: "Phantom associé à l'expérience",
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetectorScreen(experimentId: widget.experimentId),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phantom")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Type *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _dimensionsController,
                decoration: const InputDecoration(
                  labelText: "Dimensions (mm) *",
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(labelText: "Matériau"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Ajouter le phantom"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
