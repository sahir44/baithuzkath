import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/scheme_provider.dart';
import 'providers/application_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BaithuzakathApp());
}

class BaithuzakathApp extends StatelessWidget {
  const BaithuzakathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SchemeProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
      ],
      child: MaterialApp(
        title: 'Baithuzakath',
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF154C2E)),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
