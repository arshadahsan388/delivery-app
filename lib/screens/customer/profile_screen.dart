import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simple_auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/localization.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  
  Future<void> _handleLogout() async {
    try {
      await ref.read(simpleAuthProvider.notifier).logout();
      // AppWrapper will handle navigation automatically when user becomes null
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final auth = ref.watch(simpleAuthProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.profile ?? 'Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Screen - Coming Soon'),
            const SizedBox(height: 20),
            if (auth.user != null)
              Text('Welcome, ${auth.user?.name ?? 'User'}!')
            else
              const Text('Not logged in'),
          ],
        ),
      ),
    );
  }
}
