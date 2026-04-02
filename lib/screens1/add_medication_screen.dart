import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/notification_service.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}
//tst
class _AddMedicationScreenState extends State<AddMedicationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController doseController = TextEditingController();

  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medication")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [


            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Medication Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),


            TextField(
              controller: doseController,
              decoration: const InputDecoration(
                labelText: "Dose",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),


            ElevatedButton(
              onPressed: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: Text(
                selectedTime == null
                    ? "Select Time"
                    : "Time: ${selectedTime!.format(context)}",
              ),
            ),

            const SizedBox(height: 20),


            ElevatedButton(
              onPressed: () async {

                if (nameController.text.isEmpty ||
                    doseController.text.isEmpty ||
                    selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                DateTime now = DateTime.now();

                DateTime scheduledTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                Duration delay = scheduledTime.difference(now);

                if (delay.isNegative) {
                  delay = const Duration(seconds: 10);
                }


                await DatabaseHelper.instance.insertMedication({
                  "name": nameController.text,
                  "dose": doseController.text,
                  "time": selectedTime!.format(context),
                });


                await NotificationService.scheduleSimpleNotification(
                  1,
                  "Medication Reminder",
                  "Take ${nameController.text}",
                  delay,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Medication saved")),
                );

                Navigator.pop(context);
              },
              child: const Text("Save Medication"),
            ),
          ],
        ),
      ),
    );
  }
}