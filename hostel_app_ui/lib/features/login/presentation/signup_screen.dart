import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/features/shared/widgets/Scaffold/intro_scaffold.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends ConsumerState<SignupScreen> {
  final TextEditingController _hostelName = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntroScaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 32,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGN UP',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Row(
              spacing: 32,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hostelName,
                    decoration: const InputDecoration(
                      labelText: 'HOSTEL NAME',
                      hintText: 'Hostel Name',
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _hostelName,
                    decoration: const InputDecoration(
                      labelText: 'ROLE',
                      hintText: 'Role',
                    ),
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: _hostelName,
              decoration: const InputDecoration(
                labelText: 'USER NAME',
                hintText: 'Username',
              ),
            ),
            TextFormField(
              controller: _hostelName,
              decoration: const InputDecoration(
                labelText: 'EMAIL ADDRESS',
                hintText: 'Username',
              ),
            ),
            TextFormField(
              controller: _hostelName,
              decoration: const InputDecoration(
                labelText: 'PHONE NUMBER',
                hintText: 'Phone Number',
              ),
            ),
            TextFormField(
              controller: _hostelName,
              decoration: const InputDecoration(
                labelText: 'PASSWORD',
                hintText: 'Password',
              ),
            ),
            TextFormField(
              controller: _hostelName,
              decoration: const InputDecoration(
                labelText: 'CONFIRM PASSWORD',
                hintText: 'Confirm Password',
              ),
            ),
            FilledButton(
              onPressed: () {},
              child: Text(
                'SIGN UP',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    context.goNamed('login');
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
