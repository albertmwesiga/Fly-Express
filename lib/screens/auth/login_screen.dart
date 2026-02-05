import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_controller.dart';
import '../../constants/app_theme.dart';
import '../../constants/app_constants.dart';
import '../../models/account_profile.dart';
import 'registration_screen.dart';

/// Entry point for user authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  final _identifierInput = TextEditingController();
  final _passwordInput = TextEditingController();
  final _formValidator = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _identifierInput.dispose();
    _passwordInput.dispose();
    super.dispose();
  }

  Future<void> _attemptAuthentication() async {
    if (!_formValidator.currentState!.validate()) return;

    final sessionManager = context.read<SessionController>();
    final authenticated = await sessionManager.performLogin(
      _identifierInput.text.trim(),
      _passwordInput.text,
    );

    if (!authenticated && mounted) {
      _displayErrorNotification(
        sessionManager.lastError ?? 'Authentication failed. Please try again.',
      );
    }
  }

  void _displayErrorNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegistrationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _BrandingHeader(),
                  const SizedBox(height: 56),
                  _LoginFormSection(
                    formKey: _formValidator,
                    identifierController: _identifierInput,
                    passwordController: _passwordInput,
                    passwordVisible: _passwordVisible,
                    onPasswordVisibilityToggle: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
                  const SizedBox(height: 28),
                  _AuthenticationButton(onPressed: _attemptAuthentication),
                  const SizedBox(height: 20),
                  _DemoAccessSection(),
                  const SizedBox(height: 36),
                  _SignupPrompt(onTap: _navigateToSignup),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'app-logo',
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.flight_takeoff_rounded,
              size: 55,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          AppConstants.appName,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppConstants.appTagline,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LoginFormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const _LoginFormSection({
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
    required this.passwordVisible,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _CustomInputField(
            controller: identifierController,
            labelText: 'Phone Number or Email',
            hintText: '+256 XXX XXX XXX',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your credentials';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          _CustomInputField(
            controller: passwordController,
            labelText: 'Password',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: !passwordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: AppColors.textSecondary,
              ),
              onPressed: onPasswordVisibilityToggle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _CustomInputField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppColors.primary),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _AuthenticationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AuthenticationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, sessionCtrl, _) {
        final isProcessing = sessionCtrl.processingRequest;
        return Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isProcessing ? null : onPressed,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              child: Center(
                child: isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DemoAccessSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Quick Demo Access',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.divider)),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _DemoChip(label: 'User', accountType: AccountType.regularUser),
            _DemoChip(label: 'Pilot', accountType: AccountType.flightPilot),
            _DemoChip(label: 'Admin', accountType: AccountType.systemAdmin),
          ],
        ),
      ],
    );
  }
}

class _DemoChip extends StatelessWidget {
  final String label;
  final AccountType accountType;

  const _DemoChip({required this.label, required this.accountType});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          // Auto-fill demo credentials
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Demo mode: $label account'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const _SignupPrompt({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New to Fly Express? ',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Create Account',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
