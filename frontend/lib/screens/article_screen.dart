import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import 'experience_wizard_screen.dart';

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
    print("Submit button clicked!");
    if (!_formKey.currentState!.validate()) {
      print("Validation failed");
      return;
    }

    print(
      "Calling API with data: title=${_titleController.text}, authors=${_authorsController.text}, doi=${_doiController.text}",
    );
    final result = await api.createArticle({
      "title": _titleController.text,
      "authors": _authorsController.text,
      "doi": _doiController.text,
    });

    print("API result: $result");

    if (!mounted) return;

    if (result["success"]) {
      final articleId = result["data"]["article_id"];
      print("Article created with ID $articleId");
      showSuccessSnackBar(
        context: context,
        message: "Article créé avec succès",
        onContinue: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExperienceWizardScreen(articleId: articleId),
            ),
          );
        },
      );
    } else {
      print("Error: ${result['message']}");
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
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _authorsController,
                decoration: const InputDecoration(labelText: "Auteurs *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _doiController,
                decoration: const InputDecoration(labelText: "DOI *"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Champ obligatoire" : null,
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
