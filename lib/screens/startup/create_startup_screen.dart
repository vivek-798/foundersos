import 'package:flutter/material.dart';
import '../../models/startup_model.dart';
import '../../services/startup_service.dart';

class CreateStartupScreen extends StatefulWidget {
  const CreateStartupScreen({super.key});

  @override
  State<CreateStartupScreen> createState() => _CreateStartupScreenState();
}

class _CreateStartupScreenState extends State<CreateStartupScreen> {
  int currentStep = 0;
  bool isLoading = false;

  // Controllers for Step 1
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "";

  // Step 2
  String selectedStage = "";
  String selectedTeamSize = "";
  bool isPublic = true;

  // Step 3
  List<String> selectedRoles = [];
  List<String> selectedTechStack = [];

  // Step 4
  bool createRoom = true;

  // Options
  final List<String> categories = ["SaaS", "FinTech", "EdTech", "HealthTech", "AI", "E-commerce"];
  final List<String> stages = ["Idea", "Prototype", "MVP", "Seed", "Early Revenue"];
  final List<String> teamSizes = ["1-3", "4-10", "11-50"];
  final List<String> roles = ["Flutter Developer", "Backend Engineer", "UI/UX Designer", "Product Manager", "Marketer"];
  final List<String> techStack = ["Flutter", "FastAPI", "MySQL", "Python", "React", "Node.js", "Firebase", "AWS"];

  void nextStep() {
    if (currentStep == 0) {
      if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty || selectedCategory.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
        return;
      }
    } else if (currentStep == 1) {
      if (selectedStage.isEmpty || selectedTeamSize.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select stage and team size")));
        return;
      }
    } else if (currentStep == 2) {
      if (selectedRoles.isEmpty || selectedTechStack.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one role and tech stack")));
        return;
      }
    } else if (currentStep == 3) {
      submitStartup();
      return;
    }

    setState(() {
      currentStep++;
    });
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  Future<void> submitStartup() async {
    setState(() {
      isLoading = true;
    });

    try {
      final startup = StartupModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        stage: selectedStage,
        teamSize: selectedTeamSize,
        isPublic: isPublic,
        requiredRoles: selectedRoles,
        techStack: selectedTechStack,
        createRoom: createRoom,
      );

      final service = StartupService();
      await service.createStartup(startup);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Startup created successfully!")));
        // Navigate back to home or reset form
        setState(() {
          currentStep = 0;
          titleController.clear();
          descriptionController.clear();
          selectedCategory = "";
          selectedStage = "";
          selectedTeamSize = "";
          selectedRoles.clear();
          selectedTechStack.clear();
          createRoom = true;
          isPublic = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Startup", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Step ${currentStep + 1} of 4", style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: buildStepContent())),
            Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: previousStep,
                      child: const Text("Back", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isLoading ? null : nextStep,
                    child: isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(currentStep == 3 ? "Publish Startup" : "Continue", style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepContent() {
    if (currentStep == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Startup Basics", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Startup Title",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "What are you building?",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categories.map((cat) {
              return ChoiceChip(
                label: Text(cat),
                selected: selectedCategory == cat,
                onSelected: (selected) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    } else if (currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Startup Details", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Current Stage", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: stages.map((stage) {
              return ChoiceChip(
                label: Text(stage),
                selected: selectedStage == stage,
                onSelected: (selected) {
                  setState(() {
                    selectedStage = stage;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          const Text("Team Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: teamSizes.map((size) {
              return ChoiceChip(
                label: Text(size),
                selected: selectedTeamSize == size,
                onSelected: (selected) {
                  setState(() {
                    selectedTeamSize = size;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          SwitchListTile(
            title: const Text("Public Visibility", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Allow anyone to discover your startup"),
            value: isPublic,
            onChanged: (val) {
              setState(() {
                isPublic = val;
              });
            },
          ),
        ],
      );
    } else if (currentStep == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Requirements", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Required Roles", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: roles.map((role) {
              final isSelected = selectedRoles.contains(role);
              return ChoiceChip(
                label: Text(role),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (isSelected) selectedRoles.remove(role);
                    else selectedRoles.add(role);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          const Text("Tech Stack", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: techStack.map((tech) {
              final isSelected = selectedTechStack.contains(tech);
              return ChoiceChip(
                label: Text(tech),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (isSelected) selectedTechStack.remove(tech);
                    else selectedTechStack.add(tech);
                  });
                },
              );
            }).toList(),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Collaboration", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text("Create Collaboration Room", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Automatically create a room for your team to chat and manage tasks."),
            value: createRoom,
            onChanged: (val) {
              setState(() {
                createRoom = val;
              });
            },
          ),
        ],
      );
    }
  }
}
