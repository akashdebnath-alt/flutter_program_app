import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/program.dart';

class ProgramService {
  // Set to true to see the error screen while testing
  static bool simulateError = false;

  Future<List<Program>> loadPrograms() async {
    try {
      // Pretend the network is slow so you can see the spinner
      await Future.delayed(const Duration(seconds: 2));

      if (simulateError) {
        throw Exception('Simulated error');
      }

      final text = await rootBundle.loadString('assets/data/programs.json');
      final List<dynamic> data = jsonDecode(text) as List<dynamic>;

      return data
          .map((item) => Program.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Unable to load programs');
    }
  }
}