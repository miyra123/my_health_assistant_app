import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/encryption_helper.dart'; // 🔥 مهم

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  final TextEditingController recordController = TextEditingController();

  DateTime? selectedDate;
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    final data = await DatabaseHelper.instance.getRecords();
    setState(() {
      records = data;
    });
  }

  Future<void> addRecord() async {
    if (recordController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // 🔐 تشفير قبل التخزين
    String encryptedText =
    EncryptionHelper.encrypt(recordController.text);

    await DatabaseHelper.instance.insertRecord({
      "title": encryptedText, // 🔥 نخزن مشفر
      "date": selectedDate.toString(),
    });

    recordController.clear();
    setState(() {
      selectedDate = null;
    });

    loadRecords();
  }

  Future<void> deleteRecord(int id) async {
    await DatabaseHelper.instance.deleteRecord(id);
    loadRecords();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Record deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Records"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // 🟦 Input
                TextField(
                  controller: recordController,
                  decoration: const InputDecoration(
                    labelText: "Enter your record",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () async {
                    DateTime tempDate = DateTime.now();

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Select Date"),
                          content: SizedBox(
                            height: 250,
                            child: CalendarDatePicker(
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              onDateChanged: (date) {
                                tempDate = date;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDate = tempDate;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    selectedDate == null
                        ? "Select Date"
                        : "Date: ${selectedDate!.toLocal().toString().split(' ')[0]}"
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: addRecord,
                  child: const Text("Add Record"),
                ),

                const SizedBox(height: 20),

                // 🟩 عرض البيانات
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.medical_services),

                        // 🔥 هنا السحر
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "🔒 Encrypted: ${record['title']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "🔓 Decrypted: ${EncryptionHelper.decrypt(record['title'])}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        subtitle: Text(record['date']),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteRecord(record['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}