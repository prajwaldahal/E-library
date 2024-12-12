
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/auth_services.dart';
import '../services/database_helper.dart';
import '../services/secure_storage_helper.dart';
import 'authentication_view.dart';



class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<UserModel?> user;

  @override
  void initState() {
    super.initState();
    user = _fetchUserInfo();
  }

  Future<UserModel?> _fetchUserInfo() async {
    final dbHelper = DatabaseHelper.instance;
    String? uid = await SecureStorageHelper.read("uid");
    if (uid == null) return null;
    final userData = await dbHelper.getUserById(uid);
    if (userData != null) {
      return UserModel.fromMap(userData);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Container(
        width: 300,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            FutureBuilder<UserModel?>(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('No user data available.'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No user data available.'));
                } else {
                  final user = snapshot.data!;

                  return UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                    ),
                    accountName: Text(
                      user.displayName.isNotEmpty ? user.displayName : 'Name:',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    accountEmail: Text(
                      user.email.isNotEmpty ? user.email : 'Email:',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    currentAccountPicture: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: user.photoUrl.isNotEmpty
                          ? ClipOval(child: Image.network(user.photoUrl, fit: BoxFit.cover))
                          : const Icon(Icons.person, size: 50, color: Colors.teal),
                    ),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.teal),
              title: const Text('Help', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              onTap: () async {
                await SecureStorageHelper.delete('uid');
                AuthService authService = AuthService();
                await authService.signOut();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthView()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
