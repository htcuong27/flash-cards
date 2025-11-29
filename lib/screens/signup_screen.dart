import 'package:flash_cards/blocs/auth/auth_bloc.dart';
import 'package:flash_cards/core/assets/app_images.dart';
import 'package:flash_cards/core/theme/colors.dart';
import 'package:flash_cards/core/utils/utils.dart';
import 'package:flash_cards/screens/login_screen.dart';
import 'package:flash_cards/widgets/validation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _signUp() {
    if (_nameController.text.isEmpty) {
      showValidationDialog(context: context, message: 'Please enter your name');
      return;
    }
    if (_emailController.text.isEmpty) {
      showValidationDialog(context: context, message: 'Please enter your email');
      return;
    }
    if (!Utils.isEmail(_emailController.text)) {
      showValidationDialog(context: context, message: 'Please enter a valid email address');
      return;
    }
    if (_passwordController.text.isEmpty) {
      showValidationDialog(context: context, message: 'Please enter your password');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      showValidationDialog(context: context, message: 'Passwords do not match');
      return;
    }

    context.read<AuthBloc>().add(AuthSignupRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _nameController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showValidationDialog(context: context, message: state.message);
        } else if (state is AuthSignupSuccess) {
          showValidationDialog(
            context: context,
            message: 'Success! A confirmation link has been sent to your email.',
            isSuccess: true,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textColor),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Create Account', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                const SizedBox(height: 8),
                const Text('Start your learning journey!', style: TextStyle(fontSize: 18, color: AppColors.subtextColor)),
                const SizedBox(height: 32),
                _buildTextField(_nameController, 'Name'),
                const SizedBox(height: 16),
                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 16),
                _buildPasswordField(_passwordController, 'Password', _isPasswordVisible, () => setState(() => _isPasswordVisible = !_isPasswordVisible)),
                const SizedBox(height: 16),
                _buildPasswordField(_confirmPasswordController, 'Confirm Password', _isConfirmPasswordVisible, () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible)),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
                          : const Text('Sign Up', style: TextStyle(fontSize: 18)),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildDivider(),
                const SizedBox(height: 24),
                _buildSocialButton(
                  context,
                  text: 'Sign up with Google',
                  icon: AppImages.googleLogo,
                  onPressed: () => context.read<AuthBloc>().add(AuthGoogleLoginRequested()),
                ),
                const SizedBox(height: 16),
                if (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.macOS)
                  _buildSocialButton(
                    context,
                    text: 'Sign up with Apple',
                    icon: AppImages.appleLogo,
                    onPressed: () => context.read<AuthBloc>().add(AuthAppleLoginRequested()),
                    isApple: true,
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You have already had account? ", style: TextStyle(color: AppColors.subtextColor)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      child: const Text('Login', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.subtextColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inactive)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
      style: const TextStyle(color: AppColors.textColor),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.subtextColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inactive)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.subtextColor),
          onPressed: toggleVisibility,
        ),
      ),
      style: const TextStyle(color: AppColors.textColor),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Or continue with', style: TextStyle(color: AppColors.subtextColor)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, {required String text, required String icon, required VoidCallback onPressed, bool isApple = false}) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return OutlinedButton.icon(
          icon: Image.asset(icon, height: 24, width: 24),
          label: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textColor)),
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        );
      },
    );
  }
}
