import 'package:flutter/material.dart';
import '../data/program_repository.dart';
import '../data/registrations_store.dart';
import '../models/program.dart';
import '../theme/app_theme.dart';
import 'create_program_screen.dart';

class HostProgramsScreen extends StatefulWidget {
  const HostProgramsScreen({super.key});

  @override
  State<HostProgramsScreen> createState() => _HostProgramsScreenState();
}

class _HostProgramsScreenState extends State<HostProgramsScreen> {
  final repo = ProgramRepository.instance;

  @override
  void initState() {
    super.initState();
    repo.load();
  }

  void _openForm([Program? program]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProgramScreen(program: program),
      ),
    );
  }

  Future<void> _confirmDelete(Program program) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete program?'),
        content: Text(
          '"${program.title}" will be removed from the learners\' list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    final index = repo.programs.indexWhere((p) => p.id == program.id);
    repo.remove(program.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${program.title}" deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => repo.insertAt(index, program),
        ),
      ),
    );
  }

  int _registeredCount(Program program) {
    return registrations.where((r) => r.programTitle == program.title).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My programs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('New program'),
      ),
      body: ListenableBuilder(
        listenable: repo,
        builder: (context, _) {
          final programs = repo.programs;

          if (programs.isEmpty && repo.error == null && !repo.loaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (programs.isEmpty && repo.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(repo.error!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => repo.load(force: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (programs.isEmpty) {
            return const Center(
              child: Text('You have no programs yet. Tap "New program".'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final program = programs[index];
              final registered = _registeredCount(program);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Mentor: ${program.mentor}'),
                            Text(
                              '${program.durationWeeks} weeks | Starts ${program.startDate}',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.groups_outlined,
                                    size: 16, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text('$registered registered'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _openForm(program),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () => _confirmDelete(program),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}