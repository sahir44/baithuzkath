import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bhaithulzakhat/providers/application_provider.dart';
import 'package:bhaithulzakhat/screens/application_detail_screen.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplicationProvider>(
        context,
        listen: false,
      ).loadApplications();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: Consumer<ApplicationProvider>(
        builder: (context, applicationProvider, child) {
          if (applicationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (applicationProvider.applications.isEmpty) {
            return const Center(child: Text('No applications yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applicationProvider.applications.length,
            itemBuilder: (context, index) {
              final app = applicationProvider.applications[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(app.schemeName ?? 'Application'),
                  subtitle: Text('Applied on: ${app.createdAt ?? ''}'),
                  trailing: Chip(
                    label: Text(app.status),
                    backgroundColor: _getStatusColor(app.status),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ApplicationDetailsScreen(applicationId: app.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
