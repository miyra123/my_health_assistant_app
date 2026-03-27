import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void loginUser() async {
    final user = await DatabaseHelper.instance.loginUser(
      usernameController.text,
      passwordController.text,
    );

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,


        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          children: [

            const SizedBox(height: 80),


            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.health_and_safety,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "My Health Assistant App",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 40),


            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [


                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 20),


                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),

                    const SizedBox(height: 30),


                    ElevatedButton(
                      onPressed: loginUser,
                      child: const Text("Login"),
                    ),

                    const SizedBox(height: 10),


                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text("Create new account"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}