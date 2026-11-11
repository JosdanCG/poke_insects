import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photo = user?.photoURL;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundImage: photo != null ? NetworkImage(photo) : null,
              child: photo == null ? const Icon(Icons.person, size: 44) : null,
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'Sin nombre',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(user?.email ?? ''),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: authService.signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
