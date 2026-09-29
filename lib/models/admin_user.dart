import 'package:campusvault/models/user_role.dart';

/// Represents an admin or moderator user of CampusVault.
///
/// Firebase-ready design:
/// - [uid]      → Firebase Auth UID (currently a mock string)
/// - [email]    → Firebase Auth email
/// - [role]     → Will be stored in Firestore `users/{uid}` document
/// - [username] → Display name / handle
class AdminUser {
  final String uid;
  final String username;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  const AdminUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  /// Creates an [AdminUser] from a Firestore document map.
  /// Uncomment and use when Firebase is integrated.
  // factory AdminUser.fromFirestore(Map<String, dynamic> data, String uid) {
  //   return AdminUser(
  //     uid: uid,
  //     username: data['username'] as String,
  //     email: data['email'] as String,
  //     role: UserRole.values.firstWhere((r) => r.name == data['role']),
  //     createdAt: (data['createdAt'] as Timestamp).toDate(),
  //   );
  // }

  /// Converts to a Firestore-compatible map.
  // Map<String, dynamic> toFirestore() => {
  //   'username': username,
  //   'email': email,
  //   'role': role.name,
  //   'createdAt': Timestamp.fromDate(createdAt),
  // };
}
