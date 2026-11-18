import 'package:flutter/material.dart';

import 'package:capstone_barcoma/app_state.dart';
import 'package:capstone_barcoma/models/visit.dart';
import 'package:capstone_barcoma/utils/time_format.dart';
import 'package:capstone_barcoma/widgets/empty_state.dart';

class MyVisitsScreen extends StatelessWidget {
  const MyVisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: currentStudentId,
      builder: (context, studentId, _) => studentId == null ? const _EnterIdPrompt() : _VisitHistory(key: ValueKey(studentId), studentId: studentId),
    );
  }
}

class _EnterIdPrompt extends StatefulWidget {
  const _EnterIdPrompt();

  @override
  State<_EnterIdPrompt> createState() => _EnterIdPromptState();
}

class _EnterIdPromptState extends State<_EnterIdPrompt> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showVisits() {
    final id = _controller.text.trim();
    if (id.isNotEmpty) currentStudentId.value = id;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.history, size: 56),
            const SizedBox(height: 12),
            Text('See your clinic visits',
              textAlign: TextAlign.center, style: textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Enter your student ID to view your visit history.',
              textAlign: TextAlign.center, style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              onSubmitted: (_) => _showVisits(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _showVisits,
              child: const Text('View my visits'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitHistory extends StatefulWidget {
  const _VisitHistory({super.key, required this.studentId});

  final String studentId;

  @override
  State<_VisitHistory> createState() => _VisitHistoryState();
}

class _VisitHistoryState extends State<_VisitHistory> {
  late final Stream<List<Visit>> _visits = visitRepo.watchByStudent(widget.studentId);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: Text(widget.studentId),
          subtitle: const Text('Showing visits for this ID'),
          trailing: TextButton(
            onPressed: () => currentStudentId.value = null,
            child: const Text('Change'),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<List<Visit>>(
            stream: _visits,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final visits = snapshot.data!;
              if (visits.isEmpty) {
                return const EmptyState(
                  icon: Icons.inbox_outlined,
                  message: 'No visits yet for this ID.',
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: visits.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _VisitCard(visit: visits[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({required this.visit});

  final Visit visit;

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this visit?'),
        content: const Text("It will be removed from the nurse's queue."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel visit'),
          ),
        ],
      ),
    );
    if (confirmed == true) await visitRepo.cancelVisit(visit.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final waiting = visit.isWaiting;

    final statusLine = waiting ? 'Waiting · logged ${formatDateTime(visit.timestamp)}' : 'Attended · ${formatDateTime(visit.attendedAt!)}';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: waiting ? colors.tertiaryContainer : colors.primaryContainer,
          child: Icon(waiting ? Icons.hourglass_top : Icons.check),
        ),
        title: Text(visit.symptom),
        subtitle: Text(
          [statusLine, if (visit.note.isNotEmpty) visit.note].join('\n'),
        ),
        isThreeLine: visit.note.isNotEmpty,
        trailing: waiting ? TextButton(
          onPressed: () => _confirmCancel(context),
          child: const Text('Cancel'),
        )
        : null,
      ),
    );
  }
}
