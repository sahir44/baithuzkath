import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bhaithulzakhat/providers/scheme_provider.dart';
import 'package:bhaithulzakhat/screens/apply_scheme_screen.dart';

class ListSchemesScreen extends StatefulWidget {
  const ListSchemesScreen({super.key});

  @override
  State<ListSchemesScreen> createState() => _ListSchemesScreenState();
}

class _ListSchemesScreenState extends State<ListSchemesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SchemeProvider>(context, listen: false).loadSchemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Schemes')),
      body: Consumer<SchemeProvider>(
        builder: (context, schemeProvider, child) {
          if (schemeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (schemeProvider.schemes.isEmpty) {
            return const Center(child: Text('No schemes available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schemeProvider.schemes.length,
            itemBuilder: (context, index) {
              final scheme = schemeProvider.schemes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.card_giftcard)),
                  title: Text(scheme.name),
                  subtitle: Text(scheme.description ?? ''),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ApplySchemeScreen(schemeId: scheme.id),
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
