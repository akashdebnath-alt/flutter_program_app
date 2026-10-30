import 'package:flutter/material.dart';
import '../data/program_repository.dart';
import '../models/program.dart';

class CreateProgramScreen extends StatefulWidget {
  const CreateProgramScreen({super.key});

  @override
  State<CreateProgramScreen> createState() => _CreateProgramScreenState();
}

class _CreateProgramScreenState extends State<CreateProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _mentorController = TextEditingController();
  final _durationController = TextEditingController();
  final _dateController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _eligibilityController = TextEditingController();
  final _descriptionController = TextEditingController();

  AutovalidateMode _autoMode = AutovalidateMode.disabled;
  bool _saving = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _mentorController.dispose();
    _durationController.dispose();
    _dateController.dispose();
    _scheduleController.dispose();
    _eligibilityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _validateTitle(String? value) {
    final empty = _required(value, 'Please enter a program title');
    if (empty != null) return empty;
    if (value!.trim().length < 3) {
      return 'Title must have at least 3 characters';
    }
    return null;
  }

  String? _validateDuration(String? value) {
    final empty = _required(value, 'Please enter the duration in weeks');
    if (empty != null) return empty;
    final weeks = int.tryParse(value!.trim());
    if (weeks == null) {
      return 'Duration must be a number';
    }
    if (weeks < 1 || weeks > 52) {
      return 'Duration must be between 1 and 52 weeks';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    final empty = _required(value, 'Please write a description');
    if (empty != null) return empty;
    if (value!.trim().length < 20) {
      return 'Description must have at least 20 characters';
    }
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.day} ${_months[picked.month - 1]} ${picked.year}';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoMode = AutovalidateMode.onUserInteraction);
      return;
    }

    setState(() => _saving = true);

    // Pretend the server needs a moment
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final program = Program(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      mentor: _mentorController.text.trim(),
      durationWeeks: int.parse(_durationController.text.trim()),
      description: _descriptionController.text.trim(),
      startDate: _dateController.text.trim(),
      schedule: _scheduleController.text.trim(),
      eligibility: _eligibilityController.text.trim(),
    );

    ProgramRepository.instance.add(program);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${program.title}" created successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a program',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Program details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Learners will see this program in their list right away.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              autovalidateMode: _autoMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Program title',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: _validateTitle,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mentorController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Mentor name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        _required(v, 'Please enter the mentor name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (weeks)',
                      prefixIcon: Icon(Icons.schedule),
                    ),
                    validator: _validateDuration,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      labelText: 'Start date',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    validator: (v) => _required(v, 'Please pick a start date'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _scheduleController,
                    decoration: const InputDecoration(
                      labelText: 'Schedule (e.g. Mon, Wed | 6 PM to 7 PM)',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    validator: (v) => _required(v, 'Please enter the schedule'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _eligibilityController,
                    decoration: const InputDecoration(
                      labelText: 'Eligibility',
                      prefixIcon: Icon(Icons.verified_outlined),
                    ),
                    validator: (v) =>
                        _required(v, 'Please enter who can join'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                    validator: _validateDescription,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create program'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}