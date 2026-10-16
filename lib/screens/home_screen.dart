import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

const _sectionStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CURIOUS',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        // Dashboard background image, darkened so the white text stays readable
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/deshbord.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Welcome, Akash',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'What do you want to learn today?',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search programs',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 24),

            // Announcements
            const Text('Announcements', style: _sectionStyle),
            const SizedBox(height: 8),
            const Card(
              color: Color(0xFFFFE8CC),
              child: ListTile(
                leading:
                    Icon(Icons.campaign_outlined, color: AppColors.primary),
                title: Text('Upcoming workshop'),
                subtitle: Text('Flutter Basics workshop starts next Monday'),
              ),
            ),
            const SizedBox(height: 24),

            // Featured programs
            const Text('Featured programs', style: _sectionStyle),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.code)),
                title: Text('Flutter Basics'),
                subtitle: Text('4 weeks | Mentor: Mr. Das'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.campaign)),
                title: Text('Digital Marketing Bootcamp'),
                subtitle: Text('6 weeks | Mentor: Ms. Roy'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.black45,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), label: 'Programs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border), label: 'My programs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}