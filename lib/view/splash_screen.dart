import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../common/routes/routes.dart';
import '../common/styles/app_colors.dart';
import '../common/styles/app_textstyle.dart';
import '../model/user_model.dart';
import '../providers/auth_provider.dart';
import '../services/app_config_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkServerConnection();
  }

  Future<void> _checkServerConnection() async {
    bool isConnected = await AppConfigService.checkServerConnection();
    if (isConnected) {
      Future.delayed(
        const Duration(seconds: 3),
        _navigate,
      );
    } else {
      Future.delayed(
        const Duration(seconds: 3),
          _showDialog
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.splashGradientLight,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 15,
                      offset: Offset(4, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Image.asset(
                    "assets/images/logo-image.png",
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Read More, Carry Less',
                    textStyle: AppTextStyles.subtitleText.copyWith(
                      color: AppColors.primaryTextColorLight,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.progressIndicatorColorLight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigate() async {
    AuthProvider authProvider = AuthProvider();
    UserModel? user = await authProvider.checkAuthStatus();
    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.navbar);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.auth);
    }
  }

  Future<void> _showDialog() async {
    await AppConfigService.showServerErrorDialog(context);
  }
}
