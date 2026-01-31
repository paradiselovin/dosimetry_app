import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import 'phantom_screen.dart';

class MachineScreen extends StatefulWidget {
  final int experimentId;

  const MachineScreen({Key? key, required this.experimentId}) : super(key: key);

  @override
  State<MachineScreen> createState() => _MachineScreenState();
}

class _MachineScreenState extends State<MachineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _modelController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _typeController = TextEditingController();
  final _energyController = TextEditingController();
  final _collimationController = TextEditingController();
  final _settingsController = TextEditingController();

  final ApiService api = ApiService();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await api.createMachine({
      "manufacturer": _manufacturerController.text,
      "model": _modelController.text,
      "machine_type": _typeController.text,
    });

    if (!mounted) return;

    if (result["success"]) {
      final machineId = result["data"]["machine_id"];

      await api.addMachineToExperience(widget.experimentId, {
        "machine_id": machineId,
        "energy": _energyController.text,
        "collimation": _collimationController.text,
        "settings": _settingsController.text,
      });

      showSuccessSnackBar(
        context: context,
        message: "Machine ajoutée à l'expérience",
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhantomScreen(experimentId: widget.experimentId),
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
      appBar: AppBar(title: const Text("Machine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _manufacturerController,
                decoration: const InputDecoration(labelText: "Fabricant *"),
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
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Type *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _energyController,
                decoration: const InputDecoration(labelText: "Énergie *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _collimationController,
                decoration: const InputDecoration(labelText: "Collimation"),
              ),
              TextFormField(
                controller: _settingsController,
                decoration: const InputDecoration(labelText: "Réglages"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Ajouter la machine"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
