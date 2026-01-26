import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import 'upload_screen.dart';

class DetectorScreen extends StatefulWidget {
  final int experimentId;

  const DetectorScreen({Key? key, required this.experimentId})
    : super(key: key);

  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _typeController = TextEditingController();
  final _modelController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _positionController = TextEditingController();
  final _depthController = TextEditingController();
  final _orientationController = TextEditingController();

  final ApiService api = ApiService();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

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

      showSuccessSnackBar(
        context: context,
        message: "Détecteur ajouté",
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadScreen(experimentId: widget.experimentId),
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
      appBar: AppBar(title: const Text("Détecteur")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Ajouter le détecteur"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
