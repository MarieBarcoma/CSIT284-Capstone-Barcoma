import 'package:flutter/material.dart';

import 'package:capstone_barcoma/app_state.dart';
import 'package:capstone_barcoma/screens/log_visit_screen.dart';
import 'package:capstone_barcoma/screens/my_visits_screen.dart';
import 'package:capstone_barcoma/screens/nurse_queue_screen.dart';


class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tabIndex = 0;

  Future<void> _openNurseMode() async {
    final pin = await showDialog<String>(
      context: context,
      builder: (_) => const _PinDialog(),
    );
    if (!mounted || pin == null) return;

    if (pin == nursePin) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NurseQueueScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: _openNurseMode, // hidden entry for the nurse
          child: const Text('Clinic Visit Log'),
        ),
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          LogVisitScreen(onLogged: () => setState(() => _tabIndex = 1)),
          const MyVisitsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Log Visit',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'My Visits',
          ),
        ],
      ),
    );
  }
}

class _PinDialog extends StatefulWidget {
  const _PinDialog();

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nurse mode'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        obscureText: true,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'PIN'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Enter')),
      ],
    );
  }
}
