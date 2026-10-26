import 'package:flutter/material.dart';
import '../data/feedback_store.dart';
import '../models/feedback_entry.dart';
import '../models/program.dart';
import '../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  final Program program;

  const FeedbackScreen({super.key, required this.program});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentController = TextEditingController();

  int _rating = 0;
  bool _ratingError = false;
  bool _submitting = false;
  FeedbackEntry? _lastEntry;

  static const _ratingLabels = [
    'Tap a star to rate',
    'Poor',
    'Fair',
    'Good',
    'Very good',
    'Excellent',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
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

  String? _validateComments(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please write a short comment';
    }
    if (value.trim().length < 10) {
      return 'Comment must have at least 10 characters';
    }
    return null;
  }

  Future<void> _submit() async {
    final formOk = _formKey.currentState!.validate();
    final ratingOk = _rating > 0;
    setState(() => _ratingError = !ratingOk);

    if (!formOk || !ratingOk) {
      return;
    }

    setState(() => _submitting = true);

    // Pretend the server needs a moment
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final entry = FeedbackEntry(
      programTitle: widget.program.title,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      rating: _rating,
      comments: _commentController.text.trim(),
    );
    feedbackEntries.add(entry);

    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _commentController.clear();

    setState(() {
      _rating = 0;
      _submitting = false;
      _lastEntry = entry;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'How was ${widget.program.title}?',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Mentor: ${widget.program.mentor}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starNumber = i + 1;
                return IconButton(
                  iconSize: 40,
                  onPressed: () => setState(() {
                    _rating = starNumber;
                    _ratingError = false;
                  }),
                  icon: Icon(
                    starNumber <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.secondary,
                  ),
                );
              }),
            ),
            Center(
              child: Text(
                _ratingError ? 'Please select a star rating' : _ratingLabels[_rating],
                style: TextStyle(
                  color: _ratingError ? Colors.red : Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 20),

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
                      labelText: 'Your name',
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
                  TextFormField(
                    controller: _commentController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Comments',
                      hintText: 'Share your thoughts about this program',
                      alignLabelWithHint: true,
                    ),
                    validator: _validateComments,
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
                        : const Text('Submit feedback'),
                  ),
                ],
              ),
            ),

            if (_lastEntry != null) ...[
              const SizedBox(height: 24),
              Card(
                color: const Color(0xFFE8F5E9),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Thank you, ${_lastEntry!.name}!'),
                  subtitle: Text(
                    'Rating: ${_lastEntry!.rating} of 5'
                    '\nTotal feedback entries so far: ${feedbackEntries.length}',
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