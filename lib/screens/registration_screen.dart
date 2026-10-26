import 'package:flutter/material.dart';
import '../data/registrations_store.dart';
import '../models/program.dart';
import '../models/registration.dart';
import '../theme/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  final Program program;

  const RegistrationScreen({super.key, required this.program});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  static const _years = [
    'First year',
    'Second year',
    'Third year',
    'Fourth year',
    'Graduate',
  ];

  String? _year;
  bool _submitting = false;
  Registration? _lastRegistration;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must have at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final email = value.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) {
      return; // errors are shown under the fields
    }

    setState(() => _submitting = true);

    // Pretend the server needs a moment
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final registration = Registration(
      programTitle: widget.program.title,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      yearOfStudy: _year!,
    );
    registrations.add(registration);

    form.reset();
    _nameController.clear();
    _emailController.clear();

    setState(() {
      _year = null;
      _submitting = false;
      _lastRegistration = registration;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              widget.program.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Starts ${widget.program.startDate} | ${widget.program.durationWeeks} weeks',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _year,
                    decoration: const InputDecoration(
                      labelText: 'Year of study',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    items: _years
                        .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                        .toList(),
                    onChanged: (value) => _year = value,
                    validator: (value) =>
                        value == null ? 'Please choose your year' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Register'),
                  ),
                ],
              ),
            ),
            if (_lastRegistration != null) ...[
              const SizedBox(height: 24),
              Card(
                color: const Color(0xFFE8F5E9),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Registered: ${_lastRegistration!.name}'),
                  subtitle: Text(
                    '${_lastRegistration!.email} | ${_lastRegistration!.yearOfStudy}'
                    '\nTotal registrations so far: ${registrations.length}',
                  ),
                  isThreeLine: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}