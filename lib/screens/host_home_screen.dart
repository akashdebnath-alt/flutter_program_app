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
      body: Container(
        // Dashboard background image, darkened so the white text stays readable
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/deshboard.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Text(
              'Welcome, Host',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.add_circle_outline),
                title: Text('Create a program'),
                subtitle: Text('Add a new program for learners'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}