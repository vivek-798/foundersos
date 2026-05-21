import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../services/startup_service.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../models/startup_model.dart';
import '../../widgets/startup_card.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'user_posts_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  List<StartupModel> userStartups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);
    try {
      final fetchedUser = widget.userId != null
          ? await UserService().fetchUserProfile(widget.userId!)
          : await UserService().fetchProfile();
      
      final fetchedStartups = await StartupService().getUserStartups(fetchedUser.id);

      if (mounted) {
        setState(() {
          user = fetchedUser;
          userStartups = fetchedStartups.reversed.toList(); // Newest first
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.userId != null ? "Founder Profile" : "Profile",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: widget.userId != null
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    if (user != null) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfileScreen(user: user!)),
                      );
                      if (result == true) {
                        _loadProfile(); // Reload if updated
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  onPressed: () async {
                    await AuthService().logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text("Failed to load profile"))
              : RefreshIndicator(
                  onRefresh: _loadProfile,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Header
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                user!.fullName.isNotEmpty
                                    ? user!.fullName.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
                                    : 'U',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user!.fullName,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              user!.email,
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Bio
                      if (user!.bio != null && user!.bio!.isNotEmpty) ...[
                        const Text("Bio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(
                          user!.bio!,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade800, height: 1.5),
                        ),
                        const SizedBox(height: 25),
                      ],

                      // Goal
                      if (user!.goal != null && user!.goal!.isNotEmpty) ...[
                        const Text("Current Goal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.flag, color: Colors.blue.shade700),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  user!.goal!,
                                  style: TextStyle(fontSize: 16, color: Colors.blue.shade900, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],

                      // Skills
                      if (user!.skills.isNotEmpty) ...[
                        const Text("Skills", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: user!.skills.map((skill) => _buildChip(skill, Colors.indigo)).toList(),
                        ),
                        const SizedBox(height: 25),
                      ],

                      // Interests
                      if (user!.interests.isNotEmpty) ...[
                        const Text("Interests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: user!.interests.map((interest) => _buildChip(interest, Colors.teal)).toList(),
                        ),
                        const SizedBox(height: 25),
                      ],

                      // Experience
                      if (user!.hasExperience && user!.projectName != null) ...[
                        const Text("Recent Experience", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user!.projectName!,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user!.experienceDescription ?? "",
                                style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],

                      // User Posts (Activity) Section
                      const Text(
                        "Activity",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if (userStartups.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Center(
                            child: Text(
                              "No posts yet",
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                            ),
                          ),
                        )
                      else ...[
                        // Show latest startup post preview
                        StartupCard(
                          startup: userStartups.first,
                          showRequestButton: false, // Don't show request button in profile preview
                        ),
                        const SizedBox(height: 16),
                        if (userStartups.length > 1)
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPostsScreen(
                                      user: user!,
                                      startups: userStartups,
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "See More Posts",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }

  Widget _buildChip(String label, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade100),
      ),
      child: Text(
        label,
        style: TextStyle(color: color.shade700, fontWeight: FontWeight.w600),
      ),
    );
  }
}
