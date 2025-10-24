import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/login/controller/auth_controller.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final error = authState.error;

    return IntroScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveText(
              "LET'S GET STARTED",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
            ),
            ResponsiveSizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      label: Center(
                        child: ResponsiveText(
                          'EMAIL OR PHONE NO',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      hintText: 'Email or phone number',
                      errorText: error?.getFieldErrors('username')?[0],
                    ),
                    // validator: Validators.email,
                  ),
                  ResponsiveSizedBox(height: 32),
                  Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'ENTER YOUR PASSWORD',
                          hintText: 'Password',
                          errorText: error?.getFieldErrors('password')?[0],
                        ),
                        // validator: Validators.password,
                        obscureText: !showPassword,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: ResponsiveText(
                              'Forgot Password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorConstants.darkRed,
                                color: ColorConstants.darkRed,
                              ),
                            ),
                          ),
                          FilledButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(Size.zero),
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.fromLTRB(4, 2, 4, 2),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ResponsiveText(
                                  !showPassword ? 'Show' : 'Hide',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(width: 5),
                                showPassword
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
            FilledButton(
              onPressed: authState.status == AuthStatus.loading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        await authController.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
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
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Don't have an account?"),
            //     SizedBox(width: 8),
            //     GestureDetector(
            //       onTap: () {
            //         context.goNamed('signup');
            //       },
            //       child: Text(
            //         'Sign Up',
            //         style: TextStyle(color: Color(ColorConstants.darkRed)),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
