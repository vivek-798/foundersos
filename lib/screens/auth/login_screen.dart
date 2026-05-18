import 'package:flutter/material.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 60),

              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Login to continue building startups.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 50),

              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  hintText: "Email",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "Password",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () {
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    // Email Validation
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email is required")),
                      );

                      return;
                    }

                    // Check Email Format
                    if (!email.contains("@")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter valid email")),
                      );

                      return;
                    }

                    // Password Validation
                    if (password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password is required")),
                      );

                      return;
                    }

                    // Password Length
                    if (password.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Password must be at least 6 characters",
                          ),
                        ),
                      );

                      return;
                    }

                    

                    // Success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Validation Successful")),
                    );
                  },

                  child: const Text("Login", style: TextStyle(fontSize: 18)),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Text("Don't have an account?"),

                  TextButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  }, child: const Text("Signup")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
