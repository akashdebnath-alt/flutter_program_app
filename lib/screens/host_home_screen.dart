import 'package:flutter/material.dart';
import '../data/feedback_store.dart';
import '../data/program_repository.dart';
import '../data/registrations_store.dart';
import 'create_program_screen.dart';
import 'host_programs_screen.dart';
import 'login_screen.dart';
import 'participants_feedback_screen.dart';

// Use the same image name as in your home_screen.dart
const _dashboardImage = 'assets/images/deshbord.jpg';

class HostHomeScreen extends StatefulWidget {
  const HostHomeScreen({super.key});

  @override
  State<HostHomeScreen> createState() => _HostHomeScreenState();
}

class _HostHomeScreenState extends State<HostHomeScreen> {
  final repo = ProgramRepository.instance;

  @override
  void initState() {
    super.initState();
    repo.load();
  }

  // Opens a screen, and refreshes the counts when the user comes back
  Future<void> _open(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Host dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_dashboardImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: ListenableBuilder(
          listenable: repo,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Welcome, Host',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Create a program'),
                    subtitle: const Text('Add a new program for learners'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(const CreateProgramScreen()),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.menu_book_outlined),
                    title: const Text('My programs'),
                    subtitle: Text('${repo.programs.length} programs | edit or remove'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(const HostProgramsScreen()),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.groups_outlined),
                    title: const Text('Participants and feedback'),
                    subtitle: Text(
                      '${registrations.length} registered | ${feedbackEntries.length} feedback',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(const ParticipantsFeedbackScreen()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}