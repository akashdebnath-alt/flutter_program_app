import 'package:flutter/material.dart';
import '../data/feedback_store.dart';
import '../data/program_repository.dart';
import '../data/registrations_store.dart';
import '../models/feedback_entry.dart';
import '../models/program.dart';
import '../models/registration.dart';
import '../theme/app_theme.dart';

class ParticipantsFeedbackScreen extends StatefulWidget {
  const ParticipantsFeedbackScreen({super.key});

  @override
  State<ParticipantsFeedbackScreen> createState() =>
      _ParticipantsFeedbackScreenState();
}

class _ParticipantsFeedbackScreenState
    extends State<ParticipantsFeedbackScreen> {
  static const _all = 'All programs';
  String _filter = _all;

  double? _average(List<FeedbackEntry> list) {
    if (list.isEmpty) return null;
    final total = list.fold<int>(0, (sum, f) => sum + f.rating);
    return total / list.length;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ProgramRepository.instance;
    final titles = [_all, ...repo.programs.map((p) => p.title)];
    if (!titles.contains(_filter)) {
      _filter = _all;
    }

    final regs = _filter == _all
        ? registrations
        : registrations.where((r) => r.programTitle == _filter).toList();
    final feeds = _filter == _all
        ? feedbackEntries
        : feedbackEntries.where((f) => f.programTitle == _filter).toList();
    final shown = _filter == _all
        ? repo.programs
        : repo.programs.where((p) => p.title == _filter).toList();
    final average = _average(feeds);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Participants and feedback',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Participants'),
              Tab(text: 'Feedback'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: DropdownButtonFormField<String>(
                initialValue: _filter,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Show data for',
                  prefixIcon: Icon(Icons.filter_list),
                ),
                items: titles
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _filter = value ?? _all),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _overview(regs, feeds, average, shown),
                  _participants(regs),
                  _feedback(feeds),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overview(
    List<Registration> regs,
    List<FeedbackEntry> feeds,
    double? average,
    List<Program> shown,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard(
              icon: Icons.menu_book_outlined,
              value: '${shown.length}',
              label: 'Programs',
            ),
            _StatCard(
              icon: Icons.groups_outlined,
              value: '${regs.length}',
              label: 'Registrations',
            ),
            _StatCard(
              icon: Icons.rate_review_outlined,
              value: '${feeds.length}',
              label: 'Feedback entries',
            ),
            _StatCard(
              icon: Icons.star_outline,
              value: average == null ? '-' : average.toStringAsFixed(1),
              label: 'Average rating',
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'By program',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (shown.isEmpty) const Text('No programs yet'),
        for (final p in shown) _programRow(p),
      ],
    );
  }

  Widget _programRow(Program p) {
    final count = registrations.where((r) => r.programTitle == p.title).length;
    final programFeeds =
        feedbackEntries.where((f) => f.programTitle == p.title).toList();
    final avg = _average(programFeeds);

    return Card(
      child: ListTile(
        title: Text(p.title),
        subtitle: Text('$count registered | ${programFeeds.length} feedback'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 18, color: AppColors.secondary),
            const SizedBox(width: 4),
            Text(avg == null ? '-' : avg.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }

  Widget _participants(List<Registration> regs) {
    if (regs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No registrations yet.\nLearners appear here after they register.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final items = regs.reversed.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final r = items[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(r.name.isEmpty ? '?' : r.name[0].toUpperCase()),
            ),
            title: Text(r.name),
            subtitle: Text(
              '${r.email}\n${r.programTitle} | ${r.yearOfStudy}',
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _feedback(List<FeedbackEntry> feeds) {
    if (feeds.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No feedback yet.\nLearners appear here after they submit feedback.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final items = feeds.reversed.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final f = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Icon(
                        i <= f.rating ? Icons.star : Icons.star_border,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                    const Spacer(),
                    Text('${f.rating}/5'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  f.programTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'by ${f.name} (${f.email})',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(f.comments),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(label, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}