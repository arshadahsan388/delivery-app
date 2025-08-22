import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/simple_auth_provider.dart';
import '../../providers/locale_provider.dart';
import '../../models/user_model.dart';
import '../../utils/app_theme.dart';
import '../../utils/localization.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';
import '../../utils/toast_helper.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(simpleAuthProvider.notifier);
      
      try {
        await authNotifier.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        // Check if login was successful
        final authState = ref.read(simpleAuthProvider);
        if (authState.user != null && mounted) {
          if (authState.user!.role == UserRole.admin) {
            ToastHelper.showSuccess(context, 'Welcome Admin! 👨‍💼');
          } else {
            ToastHelper.showSuccess(context, 'Login Successful! 🎉');
          }
          
          // Navigation will be handled automatically by AppWrapper
          // since it watches the auth state
        } else if (authState.error != null && mounted) {
          ToastHelper.showError(context, authState.error!);
        }
      } catch (e) {
        if (mounted) {
          ToastHelper.showError(context, 'Something went wrong. Please try again.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final authState = ref.watch(simpleAuthProvider);
    final isUrdu = ref.watch(isUrduProvider);

    return LoadingOverlay(
      isLoading: authState.isLoading,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Language Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            ref.read(localeProvider.notifier).toggleLanguage();
                          },
                          icon: const Icon(Icons.language),
                          label: Text(isUrdu ? 'English' : 'اردو'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Logo and Welcome Text
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_shipping,
                            size: 50,
                            color: AppTheme.primaryColor,
                          ),
                        )
                            .animate()
                            .scale(duration: 600.ms, curve: Curves.elasticOut)
                            .then(delay: 200.ms)
                            .shimmer(duration: 1000.ms),

                        const SizedBox(height: 24),

                        Text(
                          localizations?.appName ?? 'Local Express',
                          style: AppTheme.headingLarge.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 400.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 8),

                        Text(
                          'Welcome Back!',
                          style: AppTheme.bodyLarge.copyWith(
                            color: Colors.grey[600],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: localizations?.email ?? 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 800.ms)
                        .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 16),

                    // Password Field
                    CustomTextField(
                      controller: _passwordController,
                      labelText: localizations?.password ?? 'Password',
                      hintText: 'Enter your password',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1000.ms)
                        .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 8),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(localizations?.forgotPassword ?? 'Forgot Password?'),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1200.ms),

                    const SizedBox(height: 32),

                    // Login Button
                    CustomButton(
                      text: localizations?.login ?? 'Login',
                      onPressed: _handleLogin,
                      isLoading: authState.isLoading,
                      gradient: AppTheme.primaryGradient,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1400.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 24),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations?.dontHaveAccount ?? "Don't have an account?",
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            localizations?.signup ?? 'Sign Up',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1600.ms),

                    const SizedBox(height: 40),

                    // Demo Accounts Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login Options:',
                            style: AppTheme.labelLarge.copyWith(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '👨‍💼 Admin Login (Local Only):\nEmail: admin@localexpress.com\nPassword: admin123\n\n🛒 Customer Login (Firebase):\nSign up with any email/password',
                            style: AppTheme.bodySmall.copyWith(
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 1800.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
