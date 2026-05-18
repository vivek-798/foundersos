import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Row(
          children: [
            // Search Bar
            Expanded(
              child: Container(
                height: 45,

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search founders, startups...",

                    prefixIcon: const Icon(Icons.search),

                    border: InputBorder.none,

                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            IconButton(
              onPressed: () {},

              icon: const Icon(Icons.notifications_none, color: Colors.black),
            ),

            IconButton(
              onPressed: () {},

              icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            ),
          ],
        ),
      ),

      // BODY
      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // CARD 1
          buildStartupCard(
            context: context,

            founderName: "Vivek S",

            title: "Building AI SaaS for founder collaboration",

            description:
                "Creating a platform where startup founders can connect, collaborate and build products together.",

            tags: ["Flutter", "AI", "B2B SaaS"],

            members: "+9",
          ),

          const SizedBox(height: 20),

          // CARD 2
          buildStartupCard(
            context: context,

            founderName: "Rahul",

            title: "Building FinTech analytics dashboard",

            description:
                "Looking for backend developers and UI/UX designers for a startup analytics platform.",

            tags: ["FinTech", "Backend", "UI/UX"],

            members: "+5",
          ),
        ],
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: "Rooms",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 34),
            label: "Create",
          ),
        ],
      ),
    );
  }

  // STARTUP CARD
  Widget buildStartupCard({
    required BuildContext context,
    required String founderName,
    required String title,
    required String description,
    required List<String> tags,
    required String members,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // TOP ROW
          Row(
            children: [
              const CircleAvatar(radius: 24, child: Icon(Icons.person)),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      founderName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const Text("Founder", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {},

                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // TITLE
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          // DESCRIPTION
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),

          const SizedBox(height: 18),

          // TAGS
          Wrap(
            spacing: 10,
            runSpacing: 10,

            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.blue.shade50,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // BOTTOM ROW
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,

                      isScrollControlled: true,

                      backgroundColor: Colors.transparent,

                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(24),

                          decoration: const BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,

                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              const Text(
                                "Request to Join",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Required Skills",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 15),

                              Wrap(
                                spacing: 10,
                                runSpacing: 10,

                                children: tags.map((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,

                                      borderRadius: BorderRadius.circular(30),
                                    ),

                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 25),

                              TextField(
                                maxLines: 4,

                                decoration: InputDecoration(
                                  hintText:
                                      "Tell the founder how you can contribute...",

                                  filled: true,
                                  fillColor: Colors.grey.shade100,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),

                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,
                                height: 55,

                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),

                                  onPressed: () {
                                    Navigator.pop(context);
                                  },

                                  child: const Text(
                                    "Send Request",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },

                  child: const Text("Request to Join"),
                ),
              ),

              const SizedBox(width: 16),

              // MEMBERS
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    child: Icon(Icons.person, size: 14),
                  ),

                  const SizedBox(width: 4),

                  const CircleAvatar(
                    radius: 14,
                    child: Icon(Icons.person, size: 14),
                  ),

                  const SizedBox(width: 4),

                  const CircleAvatar(
                    radius: 14,
                    child: Icon(Icons.person, size: 14),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    members,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
