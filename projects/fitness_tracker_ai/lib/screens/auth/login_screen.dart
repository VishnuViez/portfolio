import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'vishnu@demo.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _nameController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    bool success;
    if (_isRegister) {
      success = await auth.register(
          _nameController.text.trim(), _emailController.text.trim(), _passwordController.text);
    } else {
      success = await auth.login(_emailController.text.trim(), _passwordController.text);
    }
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Consumer<AuthProvider>(
              builder: (context, auth, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.fitness_center, size: 40, color: Colors.white),
                  ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 32),
                  Text(
                    _isRegister ? 'Create Account' : 'Welcome Back',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  Text(
                    _isRegister ? 'Start your fitness journey' : 'Log in to continue training',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 40),
                  if (_isRegister)
                    _buildField(_nameController, 'Full Name', Icons.person).animate().fadeIn(delay: 350.ms),
                  if (_isRegister) const SizedBox(height: 16),
                  _buildField(_emailController, 'Email', Icons.email).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 16),
                  _buildField(_passwordController, 'Password', Icons.lock, isPassword: true)
                      .animate()
                      .fadeIn(delay: 500.ms),
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    Text(auth.error!, style: const TextStyle(color: AppTheme.secondary, fontSize: 13)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : Text(_isRegister ? 'Sign Up' : 'Log In',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _isRegister = !_isRegister),
                    child: Text(
                      _isRegister ? 'Already have an account? Log in' : "Don't have an account? Sign up",
                      style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary),
        ),
        filled: true,
        fillColor: AppTheme.surface,
      ),
    );
  }
}
