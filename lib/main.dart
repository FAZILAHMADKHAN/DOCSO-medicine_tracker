import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';

/// Docso brand colors extracted from their website & app identity.
class DocsoColors {
  static const Color primary = Color(0xFF1A73E8); // Docso Blue
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFF34A853); // Health Green
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color divider = Color(0xFFE8EAED);
}

void main() {
  runApp(const MedicineTrackerApp());
}

class MedicineTrackerApp extends StatelessWidget {
  const MedicineTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderProvider()..fetchOrders(),
      child: MaterialApp(
        title: 'Docso - Medicine Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: DocsoColors.primary,
            primary: DocsoColors.primary,
            secondary: DocsoColors.accent,
            background: DocsoColors.background,
            surface: DocsoColors.surface,
          ),
          scaffoldBackgroundColor: DocsoColors.background,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: DocsoColors.textPrimary,
            elevation: 0,
            scrolledUnderElevation: 1,
            surfaceTintColor: Colors.white,
          ),
          dividerColor: DocsoColors.divider,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
