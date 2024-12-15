import 'dart:convert';
import 'package:elibrary/services/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/constants/api_constant.dart';
import '../model/user_model.dart';
import 'database_helper.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<GoogleSignInAuthentication?> selectGoogleAccount() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    return await googleUser.authentication;
  }

  Future<UserModel?> signInWithGoogle(GoogleSignInAuthentication googleAuth) async {
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    SecureStorageHelper.save("uid", userCredential.user!.uid);

    UserModel userModel = UserModel.fromFirebaseUser(userCredential.user);

    await DatabaseHelper.instance.insertUser(userModel);

    await registerUser(userModel);

    return userModel;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<UserModel?> checkAuthStatus() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel.fromFirebaseUser(user);
  }

  Future<void> registerUser(UserModel user) async {
    final url = Uri.parse(Constants.userRegistration);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": user.id,
        "full_name": user.displayName,
        "email": user.email,
        "photourl": user.photoUrl,
      }),
    );

    if (response.statusCode != 200) {
      debugPrint("Failed to register user: ${response.body}");
    }
  }
}
