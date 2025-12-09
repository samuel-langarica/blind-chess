import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/chess_board.dart';
import '../widgets/move_history.dart';
import '../services/storage_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadPersonalBest();
  }

  Future<void> _loadPersonalBest() async {
    final best = await _storageService.getPersonalBest();
    if (mounted) {
      context.read<GameState>().setPersonalBest(best);
    }
  }

  Future<void> _savePersonalBest(int best) async {
    await _storageService.savePersonalBest(best);
  }

  void _showNewGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Game'),
          content: const Text('Start a new game? Current progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GameState>().newGame();
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  void _showResignDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resign'),
          content: const Text('Are you sure you want to resign?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GameState>().resign();
              },
              child: const Text('Resign'),
            ),
          ],
        );
      },
    );
  }

  void _showGameOverDialog(String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final gameState = context.read<GameState>();
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result),
              const SizedBox(height: 16),
              Text('Legal Moves: ${gameState.consecutiveLegalMoves}'),
              Text('Illegal Attempts: ${gameState.illegalAttempts}'),
              if (gameState.consecutiveLegalMoves == gameState.personalBest &&
                  gameState.personalBest > 0)
                const Text(
                  '\n🎉 New Personal Best!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GameState>().newGame();
              },
              child: const Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blind Chess',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF1a1816),
        elevation: 0,
        centerTitle: false,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          // Save personal best when it changes
          if (gameState.consecutiveLegalMoves > 0) {
            _savePersonalBest(gameState.personalBest);
          }

          // Show game over dialog
          if (gameState.isGameOver && gameState.gameResult != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showGameOverDialog(gameState.gameResult!);
            });
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatCard(
                        'Legal Moves',
                        gameState.consecutiveLegalMoves.toString(),
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Personal Best',
                        gameState.personalBest.toString(),
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Illegal',
                        gameState.illegalAttempts.toString(),
                        Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chess board
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ChessBoard(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Move history
                  Expanded(
                    flex: 2,
                    child: MoveHistory(),
                  ),
                  const SizedBox(height: 16),

                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: gameState.isGameOver ? null : _showNewGameDialog,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('New Game'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3d3a37),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: gameState.isGameOver
                            ? null
                            : () => context.read<GameState>().togglePieceVisibility(),
                        icon: Icon(
                          gameState.isPeeking
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                        ),
                        label: Text(
                          gameState.isPeeking ? 'Hide' : 'Show',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gameState.isPeeking
                              ? const Color(0xFF81b64c)
                              : const Color(0xFF769656),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: gameState.isGameOver ? null : _showResignDialog,
                        icon: const Icon(Icons.flag, size: 18),
                        label: const Text('Resign'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFc23b22),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
