import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF000000),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo placeholder
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: const Color(0xFF2C2C2E),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.eye_slash_fill,
                      size: 64,
                      color: const Color(0xFF81b64c).withOpacity(0.3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'LOGO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '180 × 180',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[800],
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // App name
              const Text(
                'Blind Chess',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Master Chess Without Sight',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  letterSpacing: 0.2,
                ),
              ),

              const Spacer(flex: 3),

              // Play button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  color: const Color(0xFF81b64c),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.play_fill, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Settings button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.settings,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[300],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
