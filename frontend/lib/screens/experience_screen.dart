import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import 'machine_screen.dart';

class ExperienceScreen extends StatefulWidget {
  final int articleId;

  const ExperienceScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ApiService api = ApiService();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await api.createExperience({
      "article_id": widget.articleId,
      "description": _descriptionController.text,
    });

    if (!mounted) return;

    if (result["success"]) {
      final experimentId = result["data"]["experiment_id"];

      showSuccessSnackBar(
        context: context,
        message: "Expérience créée avec succès",
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MachineScreen(experimentId: experimentId),
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
      appBar: AppBar(title: const Text("Créer une expérience")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Créer l'expérience"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
