import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/program.dart';

class ProgramService {
  // The mock API: your JSON file served by GitHub
  static const apiUrl =
      'https://raw.githubusercontent.com/akashdebnath-alt/flutter_program_app/main/assets/data/programs.json';

  // Test switches
  static bool simulateError = false;
  static bool useLocalFallback = true;

  // Tells you where the last data came from (useful for screenshots and demo)
  static String lastSource = '';

  Future<List<Program>> loadPrograms() async {
    // Keeps the spinner visible for a moment
    await Future.delayed(const Duration(milliseconds: 800));

    if (simulateError) {
      throw Exception('Simulated error');
    }

    try {
      final programs = await _fromApi();
      lastSource = 'Mock API';
      return programs;
    } catch (_) {
      if (!useLocalFallback) {
        throw Exception('Unable to load programs');
      }
      try {
        final programs = await _fromAsset();
        lastSource = 'Local file (offline)';
        return programs;
      } catch (_) {
        throw Exception('Unable to load programs');
      }
    }
  }

  Future<List<Program>> _fromApi() async {
    final response = await http
        .get(Uri.parse(apiUrl))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode != 200) {
      throw Exception('Server error ${response.statusCode}');
    }
    return _parse(response.body);
  }

  Future<List<Program>> _fromAsset() async {
    final text = await rootBundle.loadString('assets/data/programs.json');
    return _parse(text);
  }

  List<Program> _parse(String text) {
    final List<dynamic> data = jsonDecode(text) as List<dynamic>;
    return data
        .map((item) => Program.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}