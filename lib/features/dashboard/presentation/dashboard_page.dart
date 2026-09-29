import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pml_3/features/auth/presentation/auth_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  static const String path = '/dashboard';
  static const String name = 'dashboard';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    final currentUser = authController.getCurrentUser();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (currentUser != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Profil'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama: ${currentUser.displayName ?? 'N/A'}'),
                          Text('Email: ${currentUser.email ?? 'N/A'}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Profil'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Input Data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Input Data feature not implemented yet')),
                );
              },
              child: const Text('Input Data'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await authController.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
