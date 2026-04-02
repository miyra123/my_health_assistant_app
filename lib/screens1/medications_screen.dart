import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'add_medication_screen.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}
//
class _MedicationsScreenState extends State<MedicationsScreen> {

  List<Map<String, dynamic>> medications = [];

  void loadMedications() async {
    final data = await DatabaseHelper.instance.getMedications();
    setState(() {
      medications = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medications"),
      ),

      body: medications.isEmpty
          ? const Center(child: Text("No medications added"))
          : ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final med = medications[index];

          return ListTile(
            title: Text(med["name"]),
            subtitle: Text("Dose: ${med["dose"]}   Time: ${med["time"]}"),

            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await DatabaseHelper.instance.deleteMedication(med["id"]);
                loadMedications();
              },
            ),
          );
        },
      ),



      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationScreen(),
            ),
          );

          loadMedications();
        },
      ),
    );
  }
}