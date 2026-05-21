import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/startup_model.dart';
import '../../widgets/startup_card.dart';

class UserPostsScreen extends StatelessWidget {
  final UserModel user;
  final List<StartupModel> startups;

  const UserPostsScreen({
    super.key,
    required this.user,
    required this.startups,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "${user.fullName}'s Posts",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: startups.length,
        itemBuilder: (context, index) {
          final startup = startups[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: StartupCard(
              startup: startup,
              showRequestButton: false, // In user post history, keep it simple
            ),
          );
        },
      ),
    );
  }
}
