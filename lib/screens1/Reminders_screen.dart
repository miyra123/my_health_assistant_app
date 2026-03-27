import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  // 🔹 تحميل البيانات
  Future<void> loadReminders() async {
    final data = await DatabaseHelper.instance.getMedications();
    setState(() {
      reminders = data;
    });
  }

  // 🔹 حذف
  Future<void> deleteReminder(int id, int index) async {
    await DatabaseHelper.instance.deleteMedication(id);

    setState(() {
      reminders.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminders"),
        centerTitle: true,
      ),
      body: reminders.isEmpty
          ? const Center(child: Text("No reminders yet"))
          : ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];

          return Card(
            child: ListTile(
              title: Text(reminder['name']),
              subtitle: Text(reminder['time']),

              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  deleteReminder(reminder['id'], index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}