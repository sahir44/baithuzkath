import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bhaithulzakhat/providers/application_provider.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final String applicationId;

  const ApplicationDetailsScreen({super.key, required this.applicationId});

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApplicationProvider>(
        context,
        listen: false,
      ).trackApplication(widget.applicationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application Details')),
      body: Consumer<ApplicationProvider>(
        builder: (context, applicationProvider, child) {
          if (applicationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final details = applicationProvider.selectedApplication;
          if (details == null) {
            return const Center(child: Text('Application not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.schemeName ?? 'Scheme',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow('Application ID', details.id),
                        _buildDetailRow('Status', details.status),
                        _buildDetailRow(
                          'Applied Date',
                          details.createdAt ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Application Timeline',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTimeline(details.timeline ?? []),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTimeline(List timeline) {
    if (timeline.isEmpty) {
      timeline = [
        {'status': 'Submitted', 'date': '2024-01-15', 'completed': true},
        {'status': 'Under Review', 'date': '2024-01-16', 'completed': true},
        {'status': 'Approved', 'date': null, 'completed': false},
        {'status': 'Completed', 'date': null, 'completed': false},
      ];
    }

    return Column(
      children: timeline.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == timeline.length - 1;
        final isCompleted = item['completed'] ?? false;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.teal : Colors.grey.shade300,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50,
                    color: isCompleted ? Colors.teal : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['status'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? Colors.black : Colors.grey,
                      ),
                    ),
                    if (item['date'] != null)
                      Text(
                        item['date'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
