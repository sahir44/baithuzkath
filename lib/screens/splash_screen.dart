import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bhaithulzakhat/providers/auth_provider.dart';
import 'package:bhaithulzakhat/screens/mobile_verification_screen.dart';
import 'package:bhaithulzakhat/screens/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await Future.delayed(const Duration(seconds: 2));
    await authProvider.checkAuthStatus();

    if (mounted) {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MobileVerificationScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF154C2E), Colors.yellow.shade700],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/bz.png', height: 100, width: 100),
              const SizedBox(height: 20),
              const Text(
                'Baithuzakath',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Charitable Services',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
