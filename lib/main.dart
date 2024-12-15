import 'package:elibrary/providers/auth_provider.dart';
import 'package:elibrary/providers/history_book_provider.dart';
import 'package:elibrary/providers/pdf_provider.dart';
import 'package:elibrary/providers/rent_provider.dart';
import 'package:elibrary/providers/rented_book_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'common/routes/routes.dart';
import 'common/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RentedBooksProvider()),
        ChangeNotifierProvider(create: (_) => PDFProvider()),
        ChangeNotifierProvider(create: (_) => HistoryRentedBooksProvider()),
        ChangeNotifierProvider(create: (_) => RentProvider()
        ),
      ],
      child: MaterialApp(
        title: 'E-library',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
