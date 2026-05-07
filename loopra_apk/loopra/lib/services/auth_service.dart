import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        return _userFromFirebase(result.user!);
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
    String phone,
    String userType,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await result.user!.updateDisplayName(name);
        return UserModel(
          id: result.user!.uid,
          name: name,
          email: email,
          phone: phone,
          userType: userType,
          createdAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  UserModel? _userFromFirebase(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? 'User',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      userType: 'farmer',
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
  }

  // For demo purposes - bypass auth
  Future<UserModel> getDemoUser() async {
    return UserModel(
      id: 'demo_user_001',
      name: 'Budi Santoso',
      email: 'budi@loopra.id',
      phone: '081234567890',
      userType: 'farmer',
      photoUrl: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}
