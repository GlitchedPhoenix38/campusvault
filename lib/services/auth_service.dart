import 'package:campusvault/data/admin_data.dart';
import 'package:campusvault/models/admin_user.dart';

/// Abstract authentication contract.
///
/// Current implementation: mock in-memory auth.
/// Future implementation: swap [MockAuthService] for [FirebaseAuthService]
/// that calls `firebase_auth` — no screen code changes required.
abstract class AuthService {
  /// Attempts login. Returns the [AdminUser] on success, null on failure.
  Future<AdminUser?> signIn(String username, String password);

  /// Signs out the current user.
  Future<void> signOut();

  /// Returns the currently signed-in [AdminUser], or null.
  AdminUser? get currentUser;
}

// ---------------------------------------------------------------------------
// MOCK IMPLEMENTATION  (no Firebase dependency)
// ---------------------------------------------------------------------------

class MockAuthService implements AuthService {
  AdminUser? _currentUser;

  @override
  Future<AdminUser?> signIn(String username, String password) async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = validateMockCredentials(username, password);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  AdminUser? get currentUser => _currentUser;
}

// ---------------------------------------------------------------------------
// FIREBASE STUB  (uncomment and swap in when ready)
// ---------------------------------------------------------------------------

// class FirebaseAuthService implements AuthService {
//   final _firebaseAuth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   AdminUser? _currentUser;
//
//   @override
//   Future<AdminUser?> signIn(String email, String password) async {
//     final credential = await _firebaseAuth.signInWithEmailAndPassword(
//       email: email, password: password,
//     );
//     final doc = await _firestore
//         .collection('users')
//         .doc(credential.user!.uid)
//         .get();
//     _currentUser = AdminUser.fromFirestore(doc.data()!, doc.id);
//     return _currentUser;
//   }
//
//   @override
//   Future<void> signOut() => _firebaseAuth.signOut();
//
//   @override
//   AdminUser? get currentUser => _currentUser;
// }

// ---------------------------------------------------------------------------
// SINGLETON — swap MockAuthService → FirebaseAuthService in one line
// ---------------------------------------------------------------------------

final AuthService authService = MockAuthService();
