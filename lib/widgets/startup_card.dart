import 'package:flutter/material.dart';
import '../models/startup_model.dart';
import '../screens/profile/profile_screen.dart';

class StartupCard extends StatelessWidget {
  final StartupModel startup;
  final String? requestStatus; // 'pending', 'accepted', 'rejected', or null
  final VoidCallback? onRequestToJoin;
  final bool isSaved;
  final VoidCallback? onSaveToggle;
  final bool showRequestButton;

  const StartupCard({
    super.key,
    required this.startup,
    this.requestStatus,
    this.onRequestToJoin,
    this.isSaved = false,
    this.onSaveToggle,
    this.showRequestButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Combine tags for display
    List<String> displayTags = [...startup.techStack, ...startup.requiredRoles];
    final String ownerInitials = startup.ownerName != null && startup.ownerName!.isNotEmpty
        ? startup.ownerName!.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
        : 'S';

    // Parse team size for mock overlapping avatars
    int teamCount = 1;
    try {
      // Try to extract any digit from team_size
      final regExp = RegExp(r'\d+');
      final match = regExp.firstMatch(startup.teamSize);
      if (match != null) {
        teamCount = int.parse(match.group(0)!);
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Creator/Owner Header Row
          GestureDetector(
            onTap: () {
              if (startup.ownerId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: startup.ownerId),
                  ),
                );
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                    ownerInitials,
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        startup.ownerName ?? "Startup Founder",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        startup.category,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onSaveToggle != null)
                  IconButton(
                    onPressed: onSaveToggle,
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.blue.shade600 : Colors.grey.shade400,
                    ),
                    splashRadius: 22,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            startup.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            startup.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Tags Section
          if (displayTags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayTags.take(4).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Footer Row: Action Button + Member Previews
          Row(
            children: [
              // Left: Action Button
              if (showRequestButton)
                Expanded(
                  child: _buildActionButton(context),
                )
              else
                const Spacer(),
              const SizedBox(width: 16),

              // Right: Member Previews (Overlapping Avatars)
              _buildMemberPreviews(teamCount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (requestStatus == 'accepted') {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 18),
            const SizedBox(width: 6),
            Text(
              "Joined Room",
              style: TextStyle(
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (requestStatus == 'pending') {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade200),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, color: Colors.amber.shade700, size: 18),
            const SizedBox(width: 6),
            Text(
              "Pending Approval",
              style: TextStyle(
                color: Colors.amber.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (requestStatus == 'rejected') {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Colors.red.shade700, size: 18),
            const SizedBox(width: 6),
            Text(
              "Request Declined",
              style: TextStyle(
                color: Colors.red.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Default: Request to Join Button
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onRequestToJoin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Request to Join",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildMemberPreviews(int count) {
    // Generate distinct background colors for avatar stacks
    final List<Color> colors = [
      Colors.blue.shade300,
      Colors.purple.shade300,
      Colors.teal.shade300,
    ];
    final List<String> initials = ['JD', 'AS', 'KM'];

    final int visibleAvatars = count > 3 ? 3 : count;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (count > 0)
          SizedBox(
            width: (visibleAvatars * 18.0) + 10,
            height: 30,
            child: Stack(
              children: List.generate(visibleAvatars, (index) {
                return Positioned(
                  left: index * 18.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: colors[index % colors.length],
                      child: Text(
                        initials[index % initials.length],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        const SizedBox(width: 4),
        Text(
          count > 3 ? "+${count - 3} others" : "$count member${count > 1 ? 's' : ''}",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
