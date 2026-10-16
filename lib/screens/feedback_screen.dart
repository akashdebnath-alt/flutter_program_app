import 'package:flutter/material.dart';
import '../models/program.dart';
import '../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  final Program program;

  const FeedbackScreen({super.key, required this.program});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();

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
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    Navigator.pop(context);
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
            const SizedBox(height: 24),

            // Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starNumber = i + 1;
                return IconButton(
                  iconSize: 40,
                  onPressed: () => setState(() => _rating = starNumber),
                  icon: Icon(
                    starNumber <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.secondary,
                  ),
                );
              }),
            ),
            Center(
              child: Text(
                _ratingLabels[_rating],
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),

            // Comments
            TextField(
              controller: _commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Share your thoughts about this program',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit feedback'),
            ),
          ],
        ),
      ),
    );
  }
}