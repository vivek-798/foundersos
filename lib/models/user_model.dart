class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? bio;
  final List<String> interests;
  final List<String> skills;
  final bool hasExperience;
  final String? projectName;
  final String? experienceDescription;
  final String? goal;
  final bool hasOnboarded;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.bio,
    required this.interests,
    required this.skills,
    required this.hasExperience,
    this.projectName,
    this.experienceDescription,
    this.goal,
    required this.hasOnboarded,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      hasExperience: json['has_experience'] ?? false,
      projectName: json['project_name'],
      experienceDescription: json['experience_description'],
      goal: json['goal'],
      hasOnboarded: json['has_onboarded'] ?? false,
    );
  }
}
