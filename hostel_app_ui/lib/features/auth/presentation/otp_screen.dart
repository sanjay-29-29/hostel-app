import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  ConsumerState<OTPVerificationScreen> createState() =>
      _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Optionally autofocus the first field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOtpString() {
    return _otpControllers.map((c) => c.text.trim()).join();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    // final authNotifier = ref.read(authNotifierProvider.notifier);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResponsiveText(
                'ENTER OTP',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
              ),
              ResponsiveSizedBox(height: 32),
              ResponsiveText(
                'Enter the OTP sent to your registered email address',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              ResponsiveSizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 60,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              letterSpacing: 4,
                            ),
                            onChanged: (value) {
                              if (value.length == 1) {
                                if (index + 1 < _focusNodes.length) {
                                  _focusNodes[index + 1].requestFocus();
                                } else {
                                  _focusNodes[index].unfocus();
                                }
                              } else if (value.isEmpty) {
                                if (index - 1 >= 0) {
                                  _focusNodes[index - 1].requestFocus();
                                  _otpControllers[index - 1]
                                      .selection = TextSelection.collapsed(
                                    offset:
                                        _otpControllers[index - 1].text.length,
                                  );
                                }
                              }
                            },
                            validator: (val) {
                              if (_getOtpString().length < 4) {
                                return null;
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                    ),

                    ResponsiveSizedBox(height: 32),
                    FilledButton(
                      onPressed: authState.status == AuthStatus.loading
                          ? null
                          : () async {
                              router.goNamed(RouteConstantsNames.resetPassword);
                            },
                      style: ButtonStyle(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (authState.status == AuthStatus.loading)
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            )
                          else
                            ResponsiveText(
                              'VERIFY OTP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: authState.status == AuthStatus.loading
                          ? null
                          : () async {
                              ToastHelper.showInfo(
                                'Resend OTP not implemented',
                              );
                            },
                      child: const ResponsiveText(
                        'RESEND OTP',
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorConstants.primaryColor,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                    ResponsiveSizedBox(height: 32),
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
