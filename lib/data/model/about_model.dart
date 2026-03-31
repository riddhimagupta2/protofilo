class AboutModel {
  final String id;
  final String bio;
  final String? profileImageUrl;
  final String? resumeUrl;
  final int yearsOfExperience;
  final String location;
  final String tagline;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? twitterUrl;

  AboutModel({
    required this.id,
    required this.bio,
    this.profileImageUrl,
    this.resumeUrl,
    required this.yearsOfExperience,
    required this.location,
    required this.tagline,
    this.githubUrl,
    this.linkedinUrl,
    this.twitterUrl,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    id: json['id'] as String,
    bio: json['bio'] as String,
    profileImageUrl: json['profile_image_url'] as String?,
    resumeUrl: json['resume_url'] as String?,
    yearsOfExperience: json['years_of_experience'] as int,
    location: json['location'] as String,
    tagline: json['tagline'] as String,
    githubUrl: json['github_url'] as String?,
    linkedinUrl: json['linkedin_url'] as String?,
    twitterUrl: json['twitter_url'] as String?,
  );
}
