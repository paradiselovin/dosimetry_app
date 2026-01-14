import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorsController = TextEditingController();
  final _doiController = TextEditingController();

  final ApiService api = ApiService();

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return; // stop si formulaire invalide
    }

    final result = await api.createArticle({
      "title": _titleController.text,
      "authors": _authorsController.text,
      "doi": _doiController.text,
    });

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Article créé avec succès"),
          backgroundColor: Colors.green,
        ),
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
      appBar: AppBar(title: const Text("Créer un article")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Titre *"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Le titre est obligatoire";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _authorsController,
                decoration: const InputDecoration(labelText: "Auteurs *"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Les auteurs sont obligatoires";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _doiController,
                decoration: const InputDecoration(labelText: "DOI *"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Le DOI est obligatoire";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submit,
                child: const Text("Créer l'article"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
