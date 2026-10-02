import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/navigation/app_shell.dart';
import 'features/habits/providers/home_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HabitCraftApp());
}

class HabitCraftApp extends StatelessWidget {
  const HabitCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController()..load(),
      child: MaterialApp(
        title: 'HabitCraft',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF120E0C),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFC9A227),
            surface: Color(0xFF1B1410),
          ),
          useMaterial3: true,
        ),
        home: const AppShell(),
      ),
    );
  }
}
