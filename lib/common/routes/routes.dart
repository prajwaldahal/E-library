import 'package:elibrary/view/navbar_view.dart';
import 'package:elibrary/view/book_detail_view.dart';
import 'package:flutter/material.dart';

import '../../model/book_model.dart';
import '../../view/authentication_view.dart';
import '../../view/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String navbar = '/navbar';
  static const String auth = '/auth';
  static const String bookDetail='/book-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    debugPrint(settings.name);
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthView());
      case navbar:
        return MaterialPageRoute(builder: (_) => NavBar());
      case bookDetail:
        final Book book =settings.arguments as Book;
        return MaterialPageRoute(builder: (_) => BookDetailScreen(book:book));
      default:
        return _errorRoute();
    }
  }


  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Page not found!'),
          ),
        );
      },
    );
  }
}
