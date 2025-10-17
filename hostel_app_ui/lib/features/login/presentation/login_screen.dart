import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    return IntroScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LET'S GET STARTED",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'EMAIL OR PHONE NO',
                hintText: 'Email or phone number',
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'ENTER YOUR PASSWORD',
                hintText: 'Password',
              ),
              obscureText: !showPassword,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(ColorConstants.darkRed),
                      color: Color(ColorConstants.darkRed),
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
                        borderRadius: BorderRadius.all(Radius.circular(4)),
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
                      Text(
                        !showPassword ? 'Show' : 'Hide',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
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
            SizedBox(height: 32),
            FilledButton(
              onPressed: () {},
              child: Text(
                'LOGIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    context.goNamed('signup');
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Color(ColorConstants.darkRed)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
