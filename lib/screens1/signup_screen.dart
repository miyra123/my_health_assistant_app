import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'Login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signupUser() async {

    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );

      return;
    }

    await DatabaseHelper.instance.insertUser(username, password);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created successfully")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Sign Up"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Username",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: signupUser,
              child: const Text("Sign Up"),
            )

          ],
        ),
      ),
    );
  }
}