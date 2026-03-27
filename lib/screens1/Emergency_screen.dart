import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController phoneController = TextEditingController();
  String savedNumber = "";

  @override
  void initState() {
    super.initState();
    loadNumber();
  }

  // 🔹 تحميل الرقم
  Future<void> loadNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedNumber = prefs.getString('emergency_number') ?? "";
    });
  }

  // 🔹 حفظ الرقم
  Future<void> saveNumber() async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a number first")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergency_number', phoneController.text);

    setState(() {
      savedNumber = phoneController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Number saved")),
    );
  }

  // 📍 جلب الموقع
  Future<String> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return "Location disabled";
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return "Permission denied";
    }

    final position = await Geolocator.getCurrentPosition();

    return "https://maps.google.com/?q=${position.latitude},${position.longitude}";
  }

  // 🚨 SOS (اتصال + SMS + موقع)
  Future<void> callSOS() async {
    if (savedNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a number first")),
      );
      return;
    }

    // 📍 الموقع
    String location = await getLocation();

    String message =
        "🚨 EMERGENCY!\nI need help!\nLocation:\n$location";

    // 📩 إرسال SMS
    final Uri sms = Uri.parse(
        "sms:$savedNumber?body=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(sms)) {
      await launchUrl(sms);
    }

    // 📞 اتصال
    final Uri phone = Uri.parse("tel:$savedNumber");

    if (await canLaunchUrl(phone)) {
      await launchUrl(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 إدخال الرقم
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Enter family/doctor number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 زر حفظ الرقم
            ElevatedButton(
              onPressed: saveNumber,
              child: const Text("Save Number"),
            ),

            const SizedBox(height: 20),

            if (savedNumber.isNotEmpty)
              Text(
                "Saved Number: $savedNumber",
                style: const TextStyle(fontSize: 16),
              ),

            const SizedBox(height: 40),

            // 🔴 زر SOS احترافي
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(60),
              ),
              onPressed: callSOS,
              child: const Text(
                "SOS",
                style: TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}