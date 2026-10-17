import 'package:flutter/material.dart';

import '../models/program.dart';
import '../theme/app_theme.dart';
import 'feedback_screen.dart';

class ProgramDetailsScreen extends StatelessWidget {
  final Program program;

  const ProgramDetailsScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Program details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Banner placeholder (from the wireframe)
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF2E2A7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.school, size: 64, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.schedule, size: 18),
                        label: Text('${program.durationWeeks} weeks'),
                      ),
                      Chip(
                        avatar: const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                        ),
                        label: Text('Starts ${program.startDate}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'About this program',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    program.description,
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  _InfoRow(
                    icon: Icons.person_outline,
                    label: 'Mentor',
                    value: program.mentor,
                  ),
                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Schedule',
                    value: program.schedule,
                  ),
                  _InfoRow(
                    icon: Icons.verified_outlined,
                    label: 'Eligibility',
                    value: program.eligibility,
                  ),
                ],
              ),
            ),

            // Buttons pinned at the bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registered for ${program.title}'),
                        ),
                      );
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FeedbackScreen(program: program),
                        ),
                      );
                    },
                    child: const Text('Give feedback'),
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

// One labelled row: icon + small label + value
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
