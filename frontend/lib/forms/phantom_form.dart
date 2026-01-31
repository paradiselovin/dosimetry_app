import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PhantomForm extends StatefulWidget {
  final int experimentId;
  final VoidCallback onSuccess;

  const PhantomForm({
    Key? key,
    required this.experimentId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<PhantomForm> createState() => _PhantomFormState();
}

class _PhantomFormState extends State<PhantomForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _materialController = TextEditingController();

  final ApiService api = ApiService();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final result = await api.createPhantom({
      "name": _nameController.text,
      "phantom_type": _typeController.text,
      "dimensions": _dimensionsController.text,
      "material": _materialController.text.isEmpty
          ? null
          : _materialController.text,
    });

    if (!mounted) return;

    if (result["success"]) {
      final phantomId = result["data"]["phantom_id"];
      await api.addPhantomToExperience(widget.experimentId, phantomId);
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
            decoration: const InputDecoration(labelText: "Dimensions (mm) *"),
            validator: (v) =>
                v == null || v.isEmpty ? "Champ obligatoire" : null,
          ),
          TextFormField(
            controller: _materialController,
            decoration: const InputDecoration(labelText: "Matériau"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Ajouter le phantom"),
          ),
        ],
      ),
    );
  }
}
