import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bhaithulzakhat/providers/auth_provider.dart';
import 'package:bhaithulzakhat/screens/otp_screen.dart';

class MobileVerificationScreen extends StatefulWidget {
  const MobileVerificationScreen({super.key});

  @override
  State<MobileVerificationScreen> createState() =>
      _MobileVerificationScreenState();
}

class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
  final TextEditingController _mobileController = TextEditingController();

  Future<void> _sendOtp() async {
    if (_mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtp(_mobileController.text);

    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(mobile: _mobileController.text),
        ),
      );
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Center(
                child: Image.asset('assets/bz.png', height: 100, width: 100),
              ),
              const SizedBox(height: 80),
              Center(
                child: const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: const Text(
                  'Enter your mobile number to continue',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                style: TextStyle(color: Colors.yellow),
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  fillColor: Colors.yellow,
                  focusColor: Colors.amber,
                  prefixIconColor: Colors.amber,
                  labelStyle: const TextStyle(color: Colors.amber),
                  hintStyle: const TextStyle(color: Colors.amber),
                  prefixStyle: const TextStyle(color: Colors.amber),
                  labelText: 'Mobile Number',
                  prefixText: '+91 ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 50),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Send OTP',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
