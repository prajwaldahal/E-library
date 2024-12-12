import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(User? user) {
    return UserModel(
      id: user?.uid ?? '',
      displayName: user?.displayName ?? '',
      email: user?.email ?? '',
      photoUrl: user?.photoURL ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}
