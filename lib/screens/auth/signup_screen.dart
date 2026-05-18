import 'package:flutter/material.dart';
import '../onboarding/onboarding_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(title: const Text("Create Account")),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                const Text(
                  "Join FoundersOS",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Build startups with like-minded people.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 40),

                // Full Name
                TextField(
                  controller: fullNameController,

                  decoration: InputDecoration(
                    hintText: "Full Name",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Email
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

                // Password
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

                const SizedBox(height: 20),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,

                  decoration: InputDecoration(
                    hintText: "Confirm Password",

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
                      String fullName = fullNameController.text.trim();

                      String email = emailController.text.trim();

                      String password = passwordController.text.trim();

                      String confirmPassword = confirmPasswordController.text
                          .trim();

                      // Full Name Validation
                      if (fullName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Full name is required"),
                          ),
                        );

                        return;
                      }

                      // Email Validation
                      if (email.isEmpty || !email.contains("@")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter valid email")),
                        );

                        return;
                      }

                      // Password Validation
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

                      // Confirm Password Validation
                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                          ),
                        );

                        return;
                      }

                      // Success
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Signup Validation Successful"),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text("Already have an account?"),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
