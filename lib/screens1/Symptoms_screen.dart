import 'package:flutter/material.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final TextEditingController controller = TextEditingController();

  String advice = "";

  void generateAdvice(String symptom) {
    symptom = symptom.toLowerCase();

    if (symptom.contains("fever")) {
      advice = "Drink fluids, rest well, and monitor your temperature.";
    } else if (symptom.contains("headache")) {
      advice = "Take rest and consider a mild pain reliever.";
    } else if (symptom.contains("cough")) {
      advice = "Stay hydrated and avoid cold drinks.";
    } else if (symptom.contains("stomach")) {
      advice = "Avoid heavy food and drink warm fluids.";
    } else if (symptom.isEmpty) {
      advice = "";
    } else {
      advice = "If symptoms continue, please consult a doctor.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptoms Checker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  generateAdvice(value);
                });
              },
              decoration: const InputDecoration(
                labelText: "Enter your symptoms",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (advice.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  advice,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}