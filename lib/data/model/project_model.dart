class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String? thumbnailUrl;
  final String? liveUrl;
  final String? githubUrl;
  final bool isFeatured;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    this.thumbnailUrl,
    this.liveUrl,
    this.githubUrl,
    this.isFeatured = false,
    required this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    techStack: List<String>.from(json['tech_stack'] ?? []),
    thumbnailUrl: json['thumbnail_url'] as String?,
    liveUrl: json['live_url'] as String?,
    githubUrl: json['github_url'] as String?,
    isFeatured: json['is_featured'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'tech_stack': techStack,
    'thumbnail_url': thumbnailUrl,
    'live_url': liveUrl,
    'github_url': githubUrl,
    'is_featured': isFeatured,
  };
}
