import 'package:campusvault/models/admin_user.dart';
import 'package:campusvault/models/resource.dart';
import 'package:campusvault/models/user_role.dart';

// ---------------------------------------------------------------------------
// MOCK ADMIN USERS
// ---------------------------------------------------------------------------

/// Super admin — credentials used for mock login.
/// username: GlitchedPhoenix38
/// password: admin123  (mock only — never store real passwords in code)
final AdminUser mockSuperAdmin = AdminUser(
  uid: 'mock_uid_superadmin_001',
  username: 'GlitchedPhoenix38',
  email: 'glitchedphoenix38@campusvault.dev',
  role: UserRole.superAdmin,
  createdAt: DateTime(2024, 1, 1),
);

final List<AdminUser> mockAdmins = [
  mockSuperAdmin,
  AdminUser(
    uid: 'mock_uid_mod_001',
    username: 'mod_jnec',
    email: 'mod.jnec@campusvault.dev',
    role: UserRole.moderator,
    createdAt: DateTime(2024, 6, 1),
  ),
];

// ---------------------------------------------------------------------------
// MOCK CREDENTIALS (for mock login screen only)
// ---------------------------------------------------------------------------

/// Returns the matching [AdminUser] for credentials, or null if invalid.
/// Replace this entire function body with Firebase Auth when integrating.
AdminUser? validateMockCredentials(String username, String password) {
  if (username == 'GlitchedPhoenix38' && password == 'admin123') {
    return mockSuperAdmin;
  }
  return null;
}

// ---------------------------------------------------------------------------
// MOCK RESOURCES
// ---------------------------------------------------------------------------

final List<Resource> mockResources = [
  Resource(
    id: 'res_001',
    title: 'Single Variable Calculus Notes - Unit 1',
    description: 'Detailed handwritten notes covering limits, derivatives, and integrals.',
    type: ResourceType.pdf,
    universityId: 'mgm',
    collegeId: 'jnec',
    programType: 'ug',
    courseId: 'jnec_cse',
    yearId: 'ug_y1',
    subjectCode: 'APS21BSL101',
    storageUrl: null, // Will be Firebase Storage URL
    uploadedBy: 'mock_uid_superadmin_001',
    uploadedAt: DateTime(2024, 8, 15),
  ),
  Resource(
    id: 'res_002',
    title: 'Python Programming Lab Manual',
    description: 'Complete lab manual with 20 experiment programs and expected outputs.',
    type: ResourceType.pdf,
    universityId: 'mgm',
    collegeId: 'jnec',
    programType: 'ug',
    courseId: 'jnec_cse',
    yearId: 'ug_y1',
    subjectCode: 'APS21ESP101',
    uploadedBy: 'mock_uid_superadmin_001',
    uploadedAt: DateTime(2024, 8, 20),
  ),
  Resource(
    id: 'res_003',
    title: 'Engineering Chemistry Reference Video',
    description: 'YouTube playlist covering all units of Engineering Chemistry.',
    type: ResourceType.externalLink,
    universityId: 'mgm',
    collegeId: 'jnec',
    programType: 'ug',
    courseId: 'jnec_cse',
    yearId: 'ug_y1',
    subjectCode: 'APS21BSL104',
    externalUrl: 'https://youtube.com/playlist?list=example',
    uploadedBy: 'mock_uid_mod_001',
    uploadedAt: DateTime(2024, 9, 1),
  ),
];

/// Returns resources filtered for a specific subject.
/// Replace with a Firestore query when integrating.
List<Resource> getResourcesForSubject(String subjectCode) =>
    mockResources.where((r) => r.subjectCode == subjectCode).toList();
