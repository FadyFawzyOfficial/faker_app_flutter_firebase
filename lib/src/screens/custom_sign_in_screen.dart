import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_router.dart';

class CustomSignInScreen extends ConsumerWidget {
  const CustomSignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* Note that declaring final authProviders = [EmailAuthProvider()] on each
    //* widget that needs it can lead to code duplication and subtle bugs.
    //* We will refactor this later on.
    final authProviders = <AuthProvider>[
      EmailAuthProvider(),
      // PhoneAuthProvider()
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SignInScreen(
        providers: authProviders,
        // To navigate to a different page when sign-in or register is successful,
        // we can use AuthStateChangeAction callbacks
        actions: [
          AuthStateChangeAction<SignedIn>(
            (context, state) => context.goNamed(AppRoute.profile.name),
          ),
          AuthStateChangeAction<UserCreated>(
            (context, state) => context.goNamed(AppRoute.profile.name),
          ),
        ],
      ),
    );
  }
}
