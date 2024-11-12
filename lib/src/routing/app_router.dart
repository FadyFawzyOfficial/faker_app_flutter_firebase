import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/custom_profile_screen.dart';
import '../screens/custom_sign_in_screen.dart';
import 'go_router_refresh_stream.dart';

enum AppRoute {
  signIn,
  profile,
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/sign-in',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    redirect: (context, state) {
      final isUserSignedIn = firebaseAuth.currentUser != null;
      if (isUserSignedIn) {
        if (state.uri.path == '/sign-in') {
          return '/profile';
        }
      } else {
        if (state.uri.path == '/profile') {
          return '/sign-in';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        builder: (context, state) => const CustomSignInScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoute.profile.name,
        builder: (context, state) => const CustomProfileScreen(),
      ),
    ],
  );
});
