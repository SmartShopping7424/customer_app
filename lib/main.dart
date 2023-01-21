import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/screens/app.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
            displayLarge: GoogleFonts.baloo2(),
            displayMedium: GoogleFonts.baloo2(),
            displaySmall: GoogleFonts.baloo2(),
            titleLarge: GoogleFonts.baloo2(),
            titleMedium: GoogleFonts.baloo2(),
            titleSmall: GoogleFonts.baloo2(),
            labelLarge: GoogleFonts.baloo2(),
            labelMedium: GoogleFonts.baloo2(),
            labelSmall: GoogleFonts.baloo2(),
            headlineLarge: GoogleFonts.baloo2(),
            headlineMedium: GoogleFonts.baloo2(),
            headlineSmall: GoogleFonts.baloo2(),
            bodyLarge: GoogleFonts.baloo2(),
            bodyMedium: GoogleFonts.baloo2(),
            bodySmall: GoogleFonts.baloo2()),
      ),
      home: App(0),
    );
  }
}


