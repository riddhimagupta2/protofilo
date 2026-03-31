class SkillModel {
  final String id;
  final String name;
  final String category;
  final int proficiency;
  final String? iconUrl;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    this.iconUrl,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
    id: json['id'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    proficiency: json['proficiency'] as int,
    iconUrl: json['icon_url'] as String?,
  );
}
