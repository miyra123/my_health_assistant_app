import 'package:flutter/material.dart';
import 'package:flutter_first/screens1/add_medication_screen.dart';
import 'screens1/login_screen.dart';
import 'screens1/home_screen.dart';
import 'screens1/reminders_screen.dart';
import 'screens1/records_screen.dart';
import 'screens1/symptoms_screen.dart';
import 'screens1/emergency_screen.dart';
import 'services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  await NotificationService.notificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFF5F7FB),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),


      home: const LoginScreen(),


      routes: {
        '/home': (context) => const HomeScreen(),
        '/medications': (context) => const AddMedicationScreen(),
        '/reminders': (context) => const RemindersScreen(),
        '/records': (context) => const RecordsScreen(),
        '/symptoms': (context) => const SymptomsScreen(),
        '/emergency': (context) => const EmergencyScreen(),
      },
    );
  }
}