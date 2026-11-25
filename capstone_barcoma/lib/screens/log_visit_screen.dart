import 'package:flutter/material.dart';

import 'package:capstone_barcoma/app_state.dart';
import 'package:capstone_barcoma/data/dummy_data.dart';

/// Student fills in ID, name and symptom, then submits.
class LogVisitScreen extends StatefulWidget {
  const LogVisitScreen({super.key, required this.onLogged});

  /// Called after a successful submit (the shell switches to My Visits).
  final VoidCallback onLogged;

  @override
  State<LogVisitScreen> createState() => _LogVisitScreenState();
}

class _LogVisitScreenState extends State<LogVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();

  String? _symptom;
  int _symptomResetKey = 0; // changing this rebuilds the dropdown empty
  bool _submitting = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? Function(String?) _required(String label) =>
      (value) => (value == null || value.trim().isEmpty)
          ? '$label is required'
          : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final studentId = _idController.text.trim();
    try {
      await visitRepo.addVisit(
        studentId: studentId,
        studentName: _nameController.text.trim(),
        symptom: _symptom!,
        note: _noteController.text.trim(),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Check your internet.')),
      );
      return;
    }
    if (!mounted) return;

    currentStudentId.value = studentId;

    // Keep ID and name filled in; clear the visit-specific fields.
    _noteController.clear();
    setState(() {
      _symptom = null;
      _symptomResetKey++;
      _submitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Visit logged. Please wait for the nurse to call you.'),
      ),
    );
    widget.onLogged();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Clinic logo
        Center(
          child: Image.asset(
            'assets/images/clinic_logo.png',
            height: 110,
          ),
        ),
        const SizedBox(height: 16),

        Text('How are you feeling?', style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          'Log your visit and the clinic nurse will see you in the queue.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  hintText: 'e.g. 21-1234-567',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: _required('Student ID'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: _required('Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(_symptomResetKey),
                initialValue: _symptom,
                decoration: const InputDecoration(
                  labelText: 'Symptom',
                  prefixIcon: Icon(Icons.healing_outlined),
                ),
                items: [
                  for (final s in symptoms)
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (value) => setState(() => _symptom = value),
                validator: (value) =>
                    value == null ? 'Please choose a symptom' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Anything the nurse should know',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit visit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}