import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pml_3/features/auth/presentation/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const String path = '/login';
  static const String name = 'login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      final authController = ref.read(authControllerProvider.notifier);
      final user = ref.read(authControllerProvider).value;

      await authController.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      if (user != null) {
        if (user.emailVerified) {
          if (mounted) {
            context.go('/dashboard');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email anda belum terverifikasi')),
            );
            authController.signOut(); // Log out if not verified
          }
        }
      } else {
        final error = ref.read(authControllerProvider).error;
        if (mounted) {
          if (error is FirebaseAuthException && (error.code == 'wrong-password' || error.code == 'user-not-found')) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Username/password salah')),
            );
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null && user.emailVerified) {
            context.go('/dashboard');
          }
        },
        error: (error, st) {
           if (error is FirebaseAuthException && error.code == 'user-not-found') {
            // Do nothing, handled by _signIn()
          } else {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          }
        }
      );
    });

    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isLoading ? null : _signIn,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('or'),
                  TextButton(
                    onPressed: () {
                      context.go('/signup');
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
