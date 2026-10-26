import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'host_home_screen.dart';

enum UserRole { student, host }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _role = UserRole.student;
  final _formKey = GlobalKey<FormState>();

void _login() {
  if (!_formKey.currentState!.validate()) {
    return; // errors are shown under the fields
  }

  final Widget next =
      _role == UserRole.student ? const HomeScreen() : const HostHomeScreen();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => next),
  );
}

  @override
  Widget build(BuildContext context) {
    final isStudent = _role == UserRole.student;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'CURIOUS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        isStudent
                            ? 'Stay curious. Keep growing.'
                            : 'Inspire minds. Build programs that matter.',
                        key: ValueKey(isStudent),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Role selector
                    SegmentedButton<UserRole>(
                      showSelectedIcon: false,
                      style: SegmentedButton.styleFrom(
                        backgroundColor: Colors.white24,
                        foregroundColor: Colors.white,
                        selectedBackgroundColor: AppColors.secondary,
                        selectedForegroundColor: Colors.black87,
                      ),
                      segments: const [
                        ButtonSegment(
                          value: UserRole.student,
                          label: Text('Student / Intern'),
                          icon: Icon(Icons.school_outlined),
                        ),
                        ButtonSegment(
                          value: UserRole.host,
                          label: Text('Host'),
                          icon: Icon(Icons.event_outlined),
                        ),
                      ],
                      selected: {_role},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _role = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must have at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text(isStudent ? 'Login as Student' : 'Login as Host'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                      ),
                      onPressed: () {},
                      child: Text(isStudent
                          ? 'New student? Sign up'
                          : 'New host? Sign up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}