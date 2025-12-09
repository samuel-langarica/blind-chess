import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const BlindChessApp());
}

class BlindChessApp extends StatelessWidget {
  const BlindChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Blind Chess',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF262421),
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF81b64c),
            secondary: const Color(0xFF769656),
            surface: const Color(0xFF312e2b),
            background: const Color(0xFF262421),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF312e2b),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: const Color(0xFF312e2b),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF81b64c),
            ),
          ),
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
