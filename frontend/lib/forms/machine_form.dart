import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MachineForm extends StatefulWidget {
  final int experimentId;
  final VoidCallback onSuccess;

  const MachineForm({
    Key? key,
    required this.experimentId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<MachineForm> createState() => _MachineFormState();
}

class _MachineFormState extends State<MachineForm> {
  final _formKey = GlobalKey<FormState>();

  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  final _typeController = TextEditingController();
  final _energyController = TextEditingController();
  final _collimationController = TextEditingController();
  final _settingsController = TextEditingController();

  final ApiService api = ApiService();

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

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

      widget.onSuccess();
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Ajouter la machine"),
          ),
        ],
      ),
    );
  }
}
