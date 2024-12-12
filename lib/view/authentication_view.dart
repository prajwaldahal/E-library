import 'package:elibrary/common/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/routes/routes.dart';
import '../providers/auth_provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          _handleLoadingState(context, authProvider);
          _handleSignInState(context, authProvider);

          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo-image.png",
                  height: 120,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    await authProvider.signInWithGoogle();
                  },
                  icon: Image.asset(
                      "assets/icons/google.png",
                      height: 24,
                  ),
                  label: const Text(
                    'Sign In with Google',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleLoadingState(BuildContext context, AuthProvider authProvider) {
    if (authProvider.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomLoadingIndicator.show(context);
      });
    }
  }

  void _handleSignInState(BuildContext context, AuthProvider authProvider) {
    if (authProvider.isSignedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomLoadingIndicator.hide(context);
        Navigator.pushReplacementNamed(context, AppRoutes.navbar);
      });
    }
  }
}
