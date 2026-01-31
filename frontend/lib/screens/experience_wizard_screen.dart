import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';
import '../forms/detector_form.dart';
import '../forms/machine_form.dart';
import '../forms/phantom_form.dart';
import '../forms/upload_form.dart';

class ExperienceWizardScreen extends StatefulWidget {
  final int articleId;

  const ExperienceWizardScreen({Key? key, required this.articleId})
    : super(key: key);

  @override
  State<ExperienceWizardScreen> createState() => _ExperienceWizardScreenState();
}

class _ExperienceWizardScreenState extends State<ExperienceWizardScreen> {
  final ApiService api = ApiService();

  int _currentStep = 0;
  int? _experimentId;

  final _descriptionFormKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  bool get _experienceCreated => _experimentId != null;

  Map<String, dynamic>? _summaryData;
  bool _isLoadingSummary = false;

  // --------------------
  // Navigation
  // --------------------
  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // --------------------
  // API call
  // --------------------
  Future<void> _createExperience() async {
    if (!_descriptionFormKey.currentState!.validate()) return;

    final result = await api.createExperience({
      "article_id": widget.articleId,
      "description": _descriptionController.text,
    });

    if (!mounted) return;

    if (result["success"]) {
      setState(() {
        _experimentId = result["data"]["experiment_id"];
        _currentStep = 1;
      });

      showSuccessSnackBar(context: context, message: "Expérience créée");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _fetchSummary() async {
    if (_experimentId == null) return {};
    final summary = await api.getExperimentSummary(_experimentId!);
    return summary;
  }

  Future<void> _loadSummary() async {
    setState(() => _isLoadingSummary = true);
    _summaryData = await _fetchSummary();
    setState(() => _isLoadingSummary = false);
  }

  // --------------------
  // Steps
  // --------------------
  List<Step> get _steps => [
    Step(
      title: const Text("Description"),
      isActive: _currentStep >= 0,
      state: _experienceCreated ? StepState.complete : StepState.indexed,
      content: Form(
        key: _descriptionFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description *"),
              validator: (v) =>
                  v == null || v.isEmpty ? "Champ obligatoire" : null,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _experienceCreated ? null : _createExperience,
              child: const Text("Créer l'expérience"),
            ),
          ],
        ),
      ),
    ),
    Step(
      title: const Text("Machine"),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: _experimentId == null
          ? const Text("Créez d'abord l'expérience")
          : MachineForm(
              experimentId: _experimentId!,
              onSuccess: () {
                setState(() => _currentStep = 2);
              },
            ),
    ),
    Step(
      title: const Text("Phantom"),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      content: _experimentId == null
          ? const Text("Créez d'abord l'expérience")
          : PhantomForm(
              experimentId: _experimentId!,
              onSuccess: () {
                setState(() => _currentStep = 3);
              },
            ),
    ),
    Step(
      title: const Text("Détecteur"),
      isActive: _currentStep >= 3,
      state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      content: _experimentId == null
          ? const Text("Créez d'abord l'expérience")
          : DetectorForm(
              experimentId: _experimentId!,
              onSuccess: () {
                setState(() => _currentStep = 4);
              },
            ),
    ),
    Step(
      title: const Text("Données"),
      isActive: _currentStep >= 4,
      state: _currentStep > 4 ? StepState.complete : StepState.indexed,
      content: _experimentId == null
          ? const Text("Créez d'abord l'expérience")
          : UploadForm(
              experimentId: _experimentId!,
              onSuccess: () {
                setState(() => _currentStep = 5);
              },
            ),
    ),
    Step(
      title: const Text("Résumé"),
      isActive: _currentStep >= 5,
      state: StepState.indexed,
      content: _isLoadingSummary
          ? const Center(child: CircularProgressIndicator())
          : _summaryData == null
          ? ElevatedButton(
              onPressed: _loadSummary,
              child: const Text("Charger le résumé"),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Description : ${_summaryData!['description'] ?? ''}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Machines
                ExpansionTile(
                  title: const Text("Machines"),
                  children: [
                    ...?_summaryData!['machines']?.map<Widget>(
                      (m) => ListTile(
                        title: Text("${m['manufacturer']} ${m['model']}"),
                        subtitle: Text(
                          "Type: ${m['machine_type']}\nÉnergie: ${m['energy']}\nCollimation: ${m['collimation'] ?? '-'}\nRéglages: ${m['settings'] ?? '-'}",
                        ),
                      ),
                    ),
                    if ((_summaryData!['machines'] ?? []).isEmpty)
                      const ListTile(title: Text("Aucune machine ajoutée")),
                  ],
                ),

                // Phantoms
                ExpansionTile(
                  title: const Text("Phantoms"),
                  children: [
                    ...?_summaryData!['phantoms']?.map<Widget>(
                      (p) => ListTile(
                        title: Text(p['name']),
                        subtitle: Text(
                          "Type: ${p['phantom_type']}\nDimensions: ${p['dimensions']}\nMatériau: ${p['material'] ?? '-'}",
                        ),
                      ),
                    ),
                    if ((_summaryData!['phantoms'] ?? []).isEmpty)
                      const ListTile(title: Text("Aucun phantom ajouté")),
                  ],
                ),

                // Détecteurs
                ExpansionTile(
                  title: const Text("Détecteurs"),
                  children: [
                    ...?_summaryData!['detectors']?.map<Widget>(
                      (d) => ListTile(
                        title: Text("${d['detector_type']} ${d['model']}"),
                        subtitle: Text(
                          "Fabricant: ${d['manufacturer']}\nPosition: ${d['position']}\nProfondeur: ${d['depth']}\nOrientation: ${d['orientation']}",
                        ),
                      ),
                    ),
                    if ((_summaryData!['detectors'] ?? []).isEmpty)
                      const ListTile(title: Text("Aucun détecteur ajouté")),
                  ],
                ),

                // Données
                ExpansionTile(
                  title: const Text("Données"),
                  children: [
                    ...?_summaryData!['data']?.map<Widget>(
                      (f) => ListTile(
                        title: Text(f['file_name']),
                        subtitle: Text(
                          "Type: ${f['data_type']}\nUnité: ${f['unit'] ?? '-'}\nDescription: ${f['description'] ?? '-'}",
                        ),
                      ),
                    ),
                    if ((_summaryData!['data'] ?? []).isEmpty)
                      const ListTile(title: Text("Aucune donnée uploadée")),
                  ],
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Expérience complète !")),
                    );
                    // Ici tu peux fermer le wizard ou retourner à la liste des articles
                  },
                  child: const Text("Terminer"),
                ),
              ],
            ),
    ),
  ];

  // --------------------
  // UI
  // --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nouvelle expérience")),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text("Retour"),
                ),
              const SizedBox(width: 8),
              if (_currentStep < _steps.length - 1)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text("Suivant"),
                ),
            ],
          );
        },
        steps: _steps,
      ),
    );
  }
}
