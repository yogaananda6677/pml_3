import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pml_3/firebase_options.dart';
import 'package:pml_3/features/auth/presentation/auth_controller.dart';
import 'package:pml_3/features/auth/presentation/login_page.dart';
import 'package:pml_3/features/auth/presentation/signup_page.dart';
import 'package:pml_3/features/dashboard/presentation/dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: LoginPage.path,
    routes: [
      GoRoute(
        path: LoginPage.path,
        name: LoginPage.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: SignUpPage.path,
        name: SignUpPage.name,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: DashboardPage.path,
        name: DashboardPage.name,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isVerfied = authState.value?.emailVerified ?? false;

      final isLoggingIn = state.fullPath == LoginPage.path;
      final isSigningUp = state.fullPath == SignUpPage.path;

      if (!isLoggedIn) {
        return (isLoggingIn || isSigningUp) ? null : LoginPage.path;
      }

      if (isLoggedIn && !isVerfied) {
        // Log out unverified users if they somehow reach here after initial login attempt
        // This case is primarily handled in LoginPage.
        // For robustness, ensure unverified users are always redirected to login.
        ref.read(authControllerProvider.notifier).signOut();
        return LoginPage.path;
      }

      if (isLoggingIn || isSigningUp) {
        return DashboardPage.path;
      }

      return null;
    },
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'PML 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: goRouter,
    );
  }
}
