import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/screens/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:customer_app/utils/pushNotification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    ref.read(pushNotificationProvider).init();
    super.initState();
  }

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
