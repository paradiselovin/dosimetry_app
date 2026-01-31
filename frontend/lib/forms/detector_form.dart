import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DetectorForm extends StatefulWidget {
  final int experimentId;
  final VoidCallback onSuccess;

  const DetectorForm({
    Key? key,
    required this.experimentId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<DetectorForm> createState() => _DetectorFormState();
}

class _DetectorFormState extends State<DetectorForm> {
  final _formKey = GlobalKey<FormState>();

  final _typeController = TextEditingController();
  final _modelController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _positionController = TextEditingController();
  final _depthController = TextEditingController();
  final _orientationController = TextEditingController();

  final ApiService api = ApiService();
  bool _isSubmitting = false;

  // ✅ _submit doit être ici, dans la State
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final result = await api.createDetector({
      "detector_type": _typeController.text,
      "model": _modelController.text,
      "manufacturer": _manufacturerController.text,
    });

    if (!mounted) return;

    if (result["success"]) {
      await api.addDetectorToExperience(widget.experimentId, {
        "detector_id": result["data"]["detector_id"],
        "position": _positionController.text,
        "depth": _depthController.text,
        "orientation": _orientationController.text,
      });

      widget.onSuccess(); // le wizard décide de l'étape suivante
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
          backgroundColor: Colors.orange,
        ),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: "Type *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          TextFormField(
            controller: _modelController,
            decoration: const InputDecoration(labelText: "Modèle *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          TextFormField(
            controller: _manufacturerController,
            decoration: const InputDecoration(labelText: "Fabricant *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          TextFormField(
            controller: _positionController,
            decoration: const InputDecoration(labelText: "Position *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          TextFormField(
            controller: _depthController,
            decoration: const InputDecoration(labelText: "Profondeur *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          TextFormField(
            controller: _orientationController,
            decoration: const InputDecoration(labelText: "Orientation *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Ajouter le détecteur"),
          ),
        ],
      ),
    );
  }
}
