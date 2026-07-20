import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recipe_controller.dart';
import '../models/recipe_model.dart';

/// Create or edit a recipe. Pass a [RecipeModel] through [Get.arguments] to
/// pre-fill the form; omit it (or pass `null`) to start blank.
class RecipeEditorScreen extends StatefulWidget {
  const RecipeEditorScreen({super.key});

  @override
  State<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends State<RecipeEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _banglaCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _caloriesCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _ingredientsCtrl = TextEditingController();
  final _stepsCtrl = TextEditingController();

  bool _isEditing = false;
  String? _originalId;

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is RecipeModel) {
      _isEditing = true;
      _originalId = arg.id;
      _idCtrl.text = arg.id;
      _titleCtrl.text = arg.title;
      _banglaCtrl.text = arg.banglaTitle;
      _imageCtrl.text = arg.image;
      _categoryCtrl.text = arg.category;
      _caloriesCtrl.text = arg.calories.toString();
      _timeCtrl.text = arg.time.toString();
      _ingredientsCtrl.text = arg.ingredients.join('\n');
      _stepsCtrl.text = arg.steps.join('\n');
    } else {
      // Sensible defaults so the form is mostly empty but valid.
      _categoryCtrl.text = 'Lunch';
      _caloriesCtrl.text = '0';
      _timeCtrl.text = '0';
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _titleCtrl.dispose();
    _banglaCtrl.dispose();
    _imageCtrl.dispose();
    _categoryCtrl.dispose();
    _caloriesCtrl.dispose();
    _timeCtrl.dispose();
    _ingredientsCtrl.dispose();
    _stepsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = Get.find<RecipeController>();

    final ingredients = _ingredientsCtrl.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final steps = _stepsCtrl.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final recipe = RecipeModel(
      id: _idCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      banglaTitle: _banglaCtrl.text.trim(),
      image: _imageCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      calories: int.tryParse(_caloriesCtrl.text.trim()) ?? 0,
      time: int.tryParse(_timeCtrl.text.trim()) ?? 0,
      ingredients: ingredients,
      steps: steps,
    );

    // If we're editing and the user changed the id, drop the old key so
    // we don't leave a stale duplicate behind in Hive.
    if (_isEditing && _originalId != null && _originalId != recipe.id) {
      final oldBox = controller.findById(_originalId!);
      if (oldBox != null) {
        // delete by previous key before writing the new one
        await Get.find<RecipeController>().deleteRecipe(_originalId!);
      }
    }

    await controller.upsertRecipe(recipe);

    Get.back();
    Get.snackbar(
      'Recipe saved',
      '${recipe.title} ${_isEditing ? "updated" : "added"}.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit recipe' : 'Add recipe'),
        actions: [
          IconButton(
            tooltip: 'Save',
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(
              controller: _idCtrl,
              label: 'ID (unique, e.g. "khichuri-01")',
              required: true,
            ),
            _field(
              controller: _titleCtrl,
              label: 'English title',
              required: true,
            ),
            _field(
              controller: _banglaCtrl,
              label: 'Bangla title',
              required: true,
            ),
            _field(
              controller: _imageCtrl,
              label: 'Image asset path (e.g. assets/images/foo.jpg)',
              required: true,
            ),
            _field(
              controller: _categoryCtrl,
              label: 'Category (Lunch / Breakfast / Snack…)',
              required: true,
            ),
            Row(
              children: [
                Expanded(
                  child: _field(
                    controller: _caloriesCtrl,
                    label: 'Calories',
                    required: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(
                    controller: _timeCtrl,
                    label: 'Time (min)',
                    required: true,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Ingredients (one per line)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _ingredientsCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Rice\nLentils\nTurmeric',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Add at least one' : null,
            ),
            const SizedBox(height: 16),
            const Text(
              'Steps (one per line)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _stepsCtrl,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Wash the rice…\nHeat oil…',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Add at least one' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(_isEditing ? 'Update recipe' : 'Add recipe'),
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    bool required = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null
            : null,
      ),
    );
  }
}