import 'package:flutter/material.dart';

class HostHomeScreen extends StatelessWidget {
  const HostHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Host dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Welcome, Host',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Create a program'),
              subtitle: Text('Add a new program for learners'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.menu_book_outlined),
              title: Text('My programs'),
              subtitle: Text('Edit or remove your programs'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.groups_outlined),
              title: Text('Participants and feedback'),
              subtitle: Text('See who joined and what they said'),
            ),
          ),
        ],
      ),
    );
  }
}