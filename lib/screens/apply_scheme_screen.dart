import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bhaithulzakhat/providers/scheme_provider.dart';
import '/providers/application_provider.dart';

class ApplySchemeScreen extends StatefulWidget {
  final String schemeId;

  const ApplySchemeScreen({super.key, required this.schemeId});

  @override
  State<ApplySchemeScreen> createState() => _ApplySchemeScreenState();
}

class _ApplySchemeScreenState extends State<ApplySchemeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchemeProvider>(
        context,
        listen: false,
      ).loadSchemeDetails(widget.schemeId);
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    final applicationProvider = Provider.of<ApplicationProvider>(
      context,
      listen: false,
    );
    final success = await applicationProvider.submitApplication(
      widget.schemeId,
      _reasonController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully')),
      );
      Navigator.pop(context);
    } else if (mounted && applicationProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(applicationProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Scheme')),
      body: Consumer<SchemeProvider>(
        builder: (context, schemeProvider, child) {
          if (schemeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final scheme = schemeProvider.selectedScheme;
          if (scheme == null) {
            return const Center(child: Text('Scheme not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(scheme.description ?? ''),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Reason for Application',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reason';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Consumer<ApplicationProvider>(
                    builder: (context, applicationProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: applicationProvider.isSubmitting
                              ? null
                              : _submitApplication,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: applicationProvider.isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Submit Application',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
