class StartupModel {
  final int? id;
  final int? ownerId;
  final String? ownerName;
  final String title;
  final String description;
  final String category;
  final String stage;
  final String teamSize;
  final bool isPublic;
  final List<String> requiredRoles;
  final List<String> techStack;
  final bool createRoom;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StartupModel({
    this.id,
    this.ownerId,
    this.ownerName,
    required this.title,
    required this.description,
    required this.category,
    required this.stage,
    required this.teamSize,
    required this.isPublic,
    required this.requiredRoles,
    required this.techStack,
    required this.createRoom,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (ownerName != null) 'owner_name': ownerName,
      'title': title,
      'description': description,
      'category': category,
      'stage': stage,
      'team_size': teamSize,
      'is_public': isPublic,
      'required_roles': requiredRoles,
      'tech_stack': techStack,
      'create_room': createRoom,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  factory StartupModel.fromJson(Map<String, dynamic> json) {
    return StartupModel(
      id: json['id'],
      ownerId: json['owner_id'],
      ownerName: json['owner_name'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      stage: json['stage'] ?? '',
      teamSize: json['team_size'] ?? '',
      isPublic: json['is_public'] ?? true,
      requiredRoles: List<String>.from(json['required_roles'] ?? []),
      techStack: List<String>.from(json['tech_stack'] ?? []),
      createRoom: json['create_room'] ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
