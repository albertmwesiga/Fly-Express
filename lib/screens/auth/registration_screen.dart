import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_controller.dart';
import '../../constants/app_theme.dart';
import '../../constants/app_constants.dart';
import '../../models/account_profile.dart';

/// Account creation interface with Uganda-specific fields
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formValidator = GlobalKey<FormState>();
  final _fullNameInput = TextEditingController();
  final _emailInput = TextEditingController();
  final _ugandaPhoneInput = TextEditingController();
  final _passwordInput = TextEditingController();
  final _companyNameInput = TextEditingController();
  
  AccountType _chosenAccountType = AccountType.regularUser;
  bool _isCorporateAccount = false;
  bool _showPassword = false;
  int _registrationStep = 0;

  @override
  void dispose() {
    _fullNameInput.dispose();
    _emailInput.dispose();
    _ugandaPhoneInput.dispose();
    _passwordInput.dispose();
    _companyNameInput.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formValidator.currentState!.validate()) return;

    final sessionManager = context.read<SessionController>();
    
    CorporateDetails? corporateData;
    if (_isCorporateAccount) {
      corporateData = CorporateDetails(
        organizationName: _companyNameInput.text.trim(),
        taxIdentifier: 'TIN-UG-${DateTime.now().millisecondsSinceEpoch}',
        employeeCount: 1,
      );
    }

    final registered = await sessionManager.performRegistration(
      fullName: _fullNameInput.text.trim(),
      emailAddress: _emailInput.text.trim(),
      ugandaPhone: _ugandaPhoneInput.text.trim(),
      accountType: _chosenAccountType,
      corporateInfo: corporateData,
    );

    if (registered && mounted) {
      Navigator.of(context).pop();
    } else if (mounted) {
      _showNotification(
        sessionManager.lastError ?? 'Registration unsuccessful',
        isError: true,
      );
    }
  }

  void _showNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Fly Express'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ProgressIndicator(currentStep: _registrationStep),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formValidator,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_registrationStep == 0) ..._buildStepOne(),
                      if (_registrationStep == 1) ..._buildStepTwo(),
                      if (_registrationStep == 2) ..._buildStepThree(),
                    ],
                  ),
                ),
              ),
            ),
            _NavigationButtons(
              currentStep: _registrationStep,
              totalSteps: 3,
              onNext: () {
                if (_registrationStep < 2) {
                  setState(() => _registrationStep++);
                } else {
                  _submitRegistration();
                }
              },
              onBack: () {
                if (_registrationStep > 0) {
                  setState(() => _registrationStep--);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStepOne() {
    return [
      const Text(
        'Account Type',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'Select the type of account you want to create',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      const SizedBox(height: 32),
      _AccountTypeSelector(
        selectedType: _chosenAccountType,
        onTypeChanged: (type) => setState(() => _chosenAccountType = type),
      ),
    ];
  }

  List<Widget> _buildStepTwo() {
    return [
      const Text(
        'Personal Information',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'Tell us about yourself',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      const SizedBox(height: 32),
      TextFormField(
        controller: _fullNameInput,
        decoration: const InputDecoration(
          labelText: 'Full Name',
          hintText: 'John Doe',
          prefixIcon: Icon(Icons.person_rounded),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: _emailInput,
        decoration: const InputDecoration(
          labelText: 'Email Address',
          hintText: 'john@example.com',
          prefixIcon: Icon(Icons.email_rounded),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (!v.contains('@')) return 'Invalid email';
          return null;
        },
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: _ugandaPhoneInput,
        decoration: const InputDecoration(
          labelText: 'Uganda Phone Number',
          hintText: '+256 7XX XXX XXX',
          prefixIcon: Icon(Icons.phone_android_rounded),
          helperText: 'Must start with +256',
        ),
        keyboardType: TextInputType.phone,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (!v.startsWith('+256')) return 'Must start with +256';
          if (v.length != 13) return 'Invalid format';
          return null;
        },
      ),
    ];
  }

  List<Widget> _buildStepThree() {
    return [
      const Text(
        'Security & Additional Info',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        'Secure your account',
        style: TextStyle(color: AppColors.textSecondary),
      ),
      const SizedBox(height: 32),
      TextFormField(
        controller: _passwordInput,
        decoration: InputDecoration(
          labelText: 'Create Password',
          hintText: 'Minimum 6 characters',
          prefixIcon: const Icon(Icons.lock_rounded),
          suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          ),
        ),
        obscureText: !_showPassword,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (v.length < 6) return 'Minimum 6 characters';
          return null;
        },
      ),
      const SizedBox(height: 24),
      SwitchListTile(
        title: const Text('Company/Organization Account'),
        subtitle: const Text('For business and bulk bookings'),
        value: _isCorporateAccount,
        onChanged: (v) => setState(() => _isCorporateAccount = v),
      ),
      if (_isCorporateAccount) ...[
        const SizedBox(height: 16),
        TextFormField(
          controller: _companyNameInput,
          decoration: const InputDecoration(
            labelText: 'Organization Name',
            hintText: 'Acme Corporation Ltd',
            prefixIcon: Icon(Icons.business_rounded),
          ),
          validator: (v) => _isCorporateAccount && (v == null || v.isEmpty) 
              ? 'Required for corporate accounts' 
              : null,
        ),
      ],
    ];
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int currentStep;

  const _ProgressIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: List.generate(3, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                color: isCompleted || isCurrent 
                    ? AppColors.primary 
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AccountTypeSelector extends StatelessWidget {
  final AccountType selectedType;
  final ValueChanged<AccountType> onTypeChanged;

  const _AccountTypeSelector({
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AccountTypeCard(
          title: 'Regular User',
          description: 'Book flights and manage trips',
          icon: Icons.person_rounded,
          isSelected: selectedType == AccountType.regularUser,
          onTap: () => onTypeChanged(AccountType.regularUser),
        ),
        const SizedBox(height: 16),
        _AccountTypeCard(
          title: 'Pilot',
          description: 'Operate drones and earn money',
          icon: Icons.flight_rounded,
          isSelected: selectedType == AccountType.flightPilot,
          onTap: () => onTypeChanged(AccountType.flightPilot),
        ),
        const SizedBox(height: 16),
        _AccountTypeCard(
          title: 'Administrator',
          description: 'Manage platform operations',
          icon: Icons.admin_panel_settings_rounded,
          isSelected: selectedType == AccountType.systemAdmin,
          onTap: () => onTypeChanged(AccountType.systemAdmin),
        ),
      ],
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _NavigationButtons({
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionController>(
      builder: (context, sessionCtrl, _) {
        final isProcessing = sessionCtrl.processingRequest;
        final isLastStep = currentStep == totalSteps - 1;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: isProcessing ? null : onBack,
                    child: const Text('Back'),
                  ),
                ),
              if (currentStep > 0) const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: isProcessing ? null : onNext,
                  child: isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(isLastStep ? 'Create Account' : 'Next'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
