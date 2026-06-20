import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Runs [action] if the user is authenticated, otherwise shows a login prompt.
/// Use this for any action that requires login: comments, likes, bookmarks, etc.
void requireAuth(BuildContext context, VoidCallback action) {
  final isAuth = context.read<AuthBloc>().state.isAuthenticated;
  if (isAuth) {
    action();
  } else {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _LoginPromptSheet(originContext: context),
    );
  }
}

class _LoginPromptSheet extends StatelessWidget {
  final BuildContext originContext;
  const _LoginPromptSheet({required this.originContext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          Icon(Icons.lock_outline, size: 48, color: Theme.of(context).primaryColor),
          const SizedBox(height: 12),
          const Text(
            'Login Required',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please log in to use this feature.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                GoRouter.of(originContext).pushNamed(Routing.login.name);
              },
              child: const Text('Log In', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue as Guest', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
