import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_service.dart';

class AuthService {
  // Pega aquí tu ID de cliente web (el mismo que ya tenías)
  static const String _webClientId =
      '941309615344-vvvkclgr1mltege39q5n9ui4msh2gq72.apps.googleusercontent.com';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> _init() async {
    if (!_initialized) {
      await _google.initialize(serverClientId: _webClientId);
      _initialized = true;
    }
  }

  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    await _init();
    final account = await _google.authenticate();
    final idToken = account.authentication.idToken;
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final cred = await _auth.signInWithCredential(credential);

    final user = cred.user;
    if (user != null) {
      try {
        await userService.guardarSiNoExiste(user);
      } catch (e) {
        debugPrint('No se pudo guardar el usuario en Firestore: $e');
      }
    }
    return cred;
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}

final authService = AuthService();
