import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/route_constants.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/auth/notifier/auth_notifier.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final error = authState.error;

    return IntroScaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveText(
              'FORGOT PASSWORD',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
            ),
            ResponsiveSizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: ResponsiveText(
                        'EMAIL OR PHONE NO',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      hintText: 'Email or phone number',
                      errorText: error?.getFieldErrors('email')?[0],
                    ),
                  ),
                  ResponsiveSizedBox(height: 32),
                  FilledButton(
                    onPressed: authState.status == AuthStatus.loading
                        ? null
                        : () async {
                            await authNotifier
                                .requestOTP(_emailController.text.trim());
                          },
                    style: ButtonStyle(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (authState.status == AuthStatus.loading)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          ResponsiveText(
                            'GENERATE OTP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
