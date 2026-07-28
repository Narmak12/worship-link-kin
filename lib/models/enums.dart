enum UserRole { talent, recruiter, admin }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.talent: return 'talent';
      case UserRole.recruiter: return 'recruiter';
      case UserRole.admin: return 'admin';
    }
  }
}
