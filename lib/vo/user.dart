class User {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarPath;
  final String? region;
  final String? campus;
  final String? interest;
  final bool? agreeService;
  final bool? agreePrivacy;
  final bool? agreePush;
  final bool? agreeEmail;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarPath,
    this.region,
    this.campus,
    this.interest,
    this.agreeService,
    this.agreePrivacy,
    this.agreePush,
    this.agreeEmail,
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarPath,
    String? region,
    String? campus,
    String? interest,
    bool? agreeService,
    bool? agreePrivacy,
    bool? agreePush,
    bool? agreeEmail,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarPath: avatarPath ?? this.avatarPath,
      region: region ?? this.region,
      campus: campus ?? this.campus,
      interest: interest ?? this.interest,
      agreeService: agreeService ?? this.agreeService,
      agreePrivacy: agreePrivacy ?? this.agreePrivacy,
      agreePush: agreePush ?? this.agreePush,
      agreeEmail: agreeEmail ?? this.agreeEmail,
    );
  }
}