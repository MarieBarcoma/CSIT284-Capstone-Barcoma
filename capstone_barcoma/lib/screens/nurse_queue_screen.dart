import 'package:flutter/material.dart';

import 'package:capstone_barcoma/app_state.dart';
import 'package:capstone_barcoma/models/visit.dart';
import 'package:capstone_barcoma/utils/time_format.dart';
import 'package:capstone_barcoma/widgets/empty_state.dart';

class NurseQueueScreen extends StatelessWidget {
  const NurseQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nurse Queue'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Waiting'),
              Tab(text: 'Attended today'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_WaitingTab(), _AttendedTab()],
        ),
      ),
    );
  }
}

class _WaitingTab extends StatefulWidget {
  const _WaitingTab();

  @override
  State<_WaitingTab> createState() => _WaitingTabState();
}

class _WaitingTabState extends State<_WaitingTab> {
  late final Stream<List<Visit>> _queue = visitRepo.watchWaiting();

  Future<void> _attend(Visit visit) async {
    await visitRepo.markAttended(visit.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${visit.studentName} marked as attended')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Visit>>(
      stream: _queue,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final queue = snapshot.data!;
        if (queue.isEmpty) {
          return const EmptyState(
            icon: Icons.check_circle_outline,
            message: 'No one is waiting right now.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: queue.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final v = queue[i];
            final lines = [
              '${v.studentId} · ${v.symptom}',
              if (v.note.isNotEmpty) v.note,
              'Since ${formatTime(v.timestamp)} (${timeAgo(v.timestamp)})',
            ];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')), // queue number
                title: Text(v.studentName),
                subtitle: Text(lines.join('\n')),
                isThreeLine: true,
                trailing: FilledButton.tonal(
                  onPressed: () => _attend(v),
                  child: const Text('Attend'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AttendedTab extends StatefulWidget {
  const _AttendedTab();

  @override
  State<_AttendedTab> createState() => _AttendedTabState();
}

class _AttendedTabState extends State<_AttendedTab> {
  late final Stream<List<Visit>> _attended = visitRepo.watchAttendedToday();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Visit>>(
      stream: _attended,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final visits = snapshot.data!;
        if (visits.isEmpty) {
          return const EmptyState(
            icon: Icons.inbox_outlined,
            message: 'No attended visits yet today.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: visits.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final v = visits[i];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.check)),
                title: Text(v.studentName),
                subtitle: Text(
                  '${v.studentId} · ${v.symptom}\n'
                  'Attended at ${formatTime(v.attendedAt!)}',
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
