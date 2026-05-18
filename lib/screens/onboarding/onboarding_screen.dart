import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentStep = 0;

  // Controllers
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  final TextEditingController projectNameController = TextEditingController();

  final TextEditingController experienceDescriptionController =
      TextEditingController();

  // Selected Data
  List<String> selectedInterests = [];
  List<String> selectedSkills = [];

  String selectedGoal = "";

  bool hasExperience = false;

  // Interest Options
  final List<String> interests = [
    "AI",
    "B2B SaaS",
    "FinTech",
    "EdTech",
    "HealthTech",
    "Developer Tools",
    "Productivity",
    "E-commerce",
  ];

  // Skills
  final List<String> skills = [
    "Frontend",
    "Backend",
    "Flutter",
    "React",
    "UI/UX",
    "AI/ML",
    "Marketing",
    "Product Management",
  ];

  // Goals
  final List<String> goals = [
    "Build Startup",
    "Join Startups",
    "Find Cofounders",
    "Explore Ideas",
  ];

  void nextStep() {
    // Step Validation
    if (currentStep == 0) {
      if (fullNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Enter full name")));

        return;
      }
    }

    if (currentStep == 1) {
      if (selectedInterests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select at least one interest")),
        );

        return;
      }
    }

    if (currentStep == 2) {
      if (selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select at least one skill")),
        );

        return;
      }
    }

    if (currentStep == 4) {
      if (selectedGoal.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Select your goal")));

        return;
      }

      // Final Submit
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Onboarding Completed")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

      return;
    }

    setState(() {
      currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Onboarding")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            Text(
              "Step ${currentStep + 1} of 5",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Expanded(child: SingleChildScrollView(child: buildStepContent())),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: nextStep,

                child: Text(
                  currentStep == 4 ? "Finish" : "Continue",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildStepContent() {
    // STEP 1 PROFILE
    if (currentStep == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Profile Setup",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          const Text("Tell us about yourself."),

          const SizedBox(height: 30),

          const Center(
            child: CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
          ),

          const SizedBox(height: 30),

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

          TextField(
            controller: bioController,
            maxLines: 4,

            decoration: InputDecoration(
              hintText: "Short Bio",

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    }

    // STEP 2 INTERESTS
    if (currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Your Interests",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: interests.map((interest) {
              bool isSelected = selectedInterests.contains(interest);

              return ChoiceChip(
                label: Text(interest),

                selected: isSelected,

                onSelected: (selected) {
                  setState(() {
                    if (isSelected) {
                      selectedInterests.remove(interest);
                    } else {
                      selectedInterests.add(interest);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }

    // STEP 3 SKILLS
    if (currentStep == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Your Skills",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: skills.map((skill) {
              bool isSelected = selectedSkills.contains(skill);

              return ChoiceChip(
                label: Text(skill),

                selected: isSelected,

                onSelected: (selected) {
                  setState(() {
                    if (isSelected) {
                      selectedSkills.remove(skill);
                    } else {
                      selectedSkills.add(skill);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    }

    // STEP 4 EXPERIENCE
    if (currentStep == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Previous Experience",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text("Have you built anything before?"),

            value: hasExperience,

            onChanged: (value) {
              setState(() {
                hasExperience = value;
              });
            },
          ),

          const SizedBox(height: 20),

          if (hasExperience) ...[
            TextField(
              controller: projectNameController,

              decoration: InputDecoration(
                hintText: "Project Name",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: experienceDescriptionController,

              maxLines: 4,

              decoration: InputDecoration(
                hintText: "Describe what you built",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      );
    }

    // STEP 5 GOAL
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Your Goal",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        Column(
          children: goals.map((goal) {
            return RadioListTile(
              title: Text(goal),

              value: goal,

              groupValue: selectedGoal,

              onChanged: (value) {
                setState(() {
                  selectedGoal = value!;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
