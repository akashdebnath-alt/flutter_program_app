import 'package:flutter/foundation.dart';
import '../models/program.dart';
import '../services/program_service.dart';

class ProgramRepository extends ChangeNotifier {
  ProgramRepository._();

  // One shared instance for the whole app
  static final ProgramRepository instance = ProgramRepository._();

  List<Program> _programs = [];
  bool _loading = false;
  bool _loaded = false;
  String? _error;

  List<Program> get programs => List.unmodifiable(_programs);
  bool get loading => _loading;
  bool get loaded => _loaded;
  String? get error => _error;

  Future<void> load({bool force = false}) async {
    if (_loading) return;
    if (_loaded && !force) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _programs = await ProgramService().loadPrograms();
      _loaded = true;
    } catch (_) {
      _error = 'Unable to load programs, please try again';
    }

    _loading = false;
    notifyListeners();
  }

  void add(Program program) {
    _programs.insert(0, program);
    notifyListeners();
  }

  void update(Program program) {
    final index = _programs.indexWhere((p) => p.id == program.id);
    if (index == -1) return;
    _programs[index] = program;
    notifyListeners();
  }

  void remove(String id) {
    _programs.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}