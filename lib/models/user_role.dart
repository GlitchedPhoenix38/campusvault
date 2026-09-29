/// Defines the roles available in CampusVault.
/// Future: map these to Firebase custom claims.
enum UserRole {
  superAdmin('Super Admin', 'Full system access'),
  moderator('Moderator', 'Can upload and manage resources'),
  student('Student', 'Read-only access to resources');

  final String label;
  final String description;

  const UserRole(this.label, this.description);
}
