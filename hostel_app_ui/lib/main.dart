import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Hostel App',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(ColorConstants.darkRed)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(ColorConstants.darkRed)),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: Color(ColorConstants.darkRed),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                return Color(ColorConstants.darkRed);
              }),
            ),
          ),
        ),
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
