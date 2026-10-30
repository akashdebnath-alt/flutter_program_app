import 'package:flutter/material.dart';
import 'create_program_screen.dart';
import 'login_screen.dart';

// Use the same image name as in your home_screen.dart
const _dashboardImage = 'assets/images/deshbord.jpg';

class HostHomeScreen extends StatelessWidget {
  const HostHomeScreen({super.key});

  void _comingSoon(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name is coming in the next lesson')),
    );
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
        child: ListView(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateProgramScreen(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: const Text('My programs'),
                subtitle: const Text('Edit or remove your programs'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _comingSoon(context, 'My programs'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: const Text('Participants and feedback'),
                subtitle: const Text('See who joined and what they said'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _comingSoon(context, 'Participants and feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}