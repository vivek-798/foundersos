import 'package:flutter/material.dart';
import '../../services/startup_service.dart';
import '../../services/request_service.dart';
import '../../services/user_service.dart';
import '../../models/startup_model.dart';
import '../../models/user_model.dart';
import '../../widgets/startup_card.dart';
import '../notifications/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StartupModel> startups = [];
  UserModel? currentUser;
  Map<int, String> sentRequests = {};
  int pendingRequestsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStartups();
  }

  Future<void> fetchStartups() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fetchedStartups = await StartupService().getStartups();
      final userProfile = await UserService().fetchProfile();
      final sentReqsMap = await RequestService().fetchSentRequestsMap();
      final incomingReqs = await RequestService().fetchIncomingRequests();

      if (mounted) {
        setState(() {
          startups = fetchedStartups.reversed.toList(); // Newest first
          currentUser = userProfile;
          sentRequests = sentReqsMap;
          pendingRequestsCount = incomingReqs.length;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      // BODY
      body: Column(
        children: [
          // Top Search Bar Area (formerly AppBar)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search founders, startups...",
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                        );
                        fetchStartups(); // Refresh after coming back
                      },
                      icon: const Icon(Icons.notifications_none, color: Colors.black),
                    ),
                    if (pendingRequestsCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$pendingRequestsCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                ),
              ],
            ),
          ),

          // Main Feed
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchStartups,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : startups.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.rocket_launch, size: 80, color: Colors.grey.shade300),
                                const SizedBox(height: 20),
                                Text(
                                  "No startups found",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Be the first to build something amazing!",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: startups.length,
                          itemBuilder: (context, index) {
                            final startup = startups[index];
                            List<String> displayTags = [...startup.techStack, ...startup.requiredRoles];
                            final isOwner = currentUser != null && startup.ownerId == currentUser!.id;
                            final reqStatus = sentRequests[startup.id];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: StartupCard(
                                startup: startup,
                                requestStatus: reqStatus,
                                showRequestButton: !isOwner,
                                onRequestToJoin: () {
                                  if (startup.id != null) {
                                    showJoinModal(context, startup.id!, displayTags);
                                  }
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void showJoinModal(BuildContext context, int startupId, List<String> tags) {
    final TextEditingController messageController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                  const Text("Request to Join", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Required Skills", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(30)),
                        child: Text(tag, style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: messageController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Tell the founder how you can contribute...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              setModalState(() {
                                isSubmitting = true;
                              });
                              try {
                                final success = await RequestService().sendJoinRequest(
                                  startupId,
                                  messageController.text.trim(),
                                );
                                if (success && context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Request sent successfully!")),
                                  );
                                  fetchStartups();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  setModalState(() {
                                    isSubmitting = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
                      child: isSubmitting
                          ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)))
                          : const Text("Send Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
