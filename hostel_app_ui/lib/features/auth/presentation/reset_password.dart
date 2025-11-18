import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/auth/notifier/auth_notifier.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;

  bool get _isFormValid {
    final pw = _passwordController.text;
    final cpw = _confirmPasswordController.text;
    return pw.isNotEmpty && pw.length >= 8 && pw == cpw;
  }

  @override
  void initState() {
    super.initState();
  }

  void onToggleShow() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    // final authNotifier = ref.read(authNotifierProvider.notifier);
    final error = authState.error;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        router.goNamed(RouteConstantsNames.login);
        return false;
      },
      child: IntroScaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveText(
                'RESET PASSWORD',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
              ),
              const ResponsiveSizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'NEW PASSWORD',
                            hintText: 'Enter Your New Password',
                            errorText: error?.getFieldErrors('new_password')?[0],
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Password is required';
                            if (value.length < 8)
                              return 'Password must be at least 8 characters';
                            return null;
                          },
                        ),
                        const ResponsiveSizedBox(height: 32),
      
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'CONFIRM PASSWORD',
                            hintText: 'Enter Again Your Password',
                            errorText: error?.getFieldErrors(
                              'confirm_password',
                            )?[0],
                            suffixIcon: IconButton(
                              onPressed: onToggleShow,
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          obscureText: !showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please confirm password';
                            if (value != _passwordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      
              const SizedBox(height: 32),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: _isFormValid
                      ? ColorConstants.darkRed
                      : Colors.grey,
                ),
                onPressed: authState.status == AuthStatus.loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          ToastHelper.showInfo('Updating password...');
                        }
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (authState.status == AuthStatus.loading && _isFormValid)
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    else
                      const ResponsiveText(
                        'UPDATE PASSWORD',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
