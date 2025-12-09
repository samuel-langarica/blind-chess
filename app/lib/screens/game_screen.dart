import 'package:flutter/cupertino.dart';
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
  bool _showMoveHistory = false;

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
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF000000),
      child: Consumer<GameState>(
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

          return Stack(
            children: [
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Top bar with back button and stats
                    _buildTopBar(gameState),

                    // Chess board - takes most of the screen
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ChessBoard(),
                          ),
                        ),
                      ),
                    ),

                    // Bottom controls
                    _buildBottomControls(gameState),
                  ],
                ),
              ),

              // Move history overlay
              if (_showMoveHistory)
                GestureDetector(
                  onTap: () => setState(() => _showMoveHistory = false),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              if (_showMoveHistory)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildMoveHistorySheet(gameState),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(GameState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          // Back button
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),

          // Stats - compact
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCompactStat(
                  'Legal',
                  gameState.consecutiveLegalMoves.toString(),
                  const Color(0xFF81b64c),
                ),
                _buildCompactStat(
                  'Best',
                  gameState.personalBest.toString(),
                  const Color(0xFF4A9DFF),
                ),
                _buildCompactStat(
                  'Illegal',
                  gameState.illegalAttempts.toString(),
                  const Color(0xFFFF453A),
                ),
              ],
            ),
          ),

          // New game button
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: gameState.isGameOver ? null : _showNewGameDialog,
            child: Icon(
              CupertinoIcons.refresh_thick,
              color: gameState.isGameOver ? Colors.grey[800] : Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(GameState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Resign button
          _buildIconButton(
            icon: CupertinoIcons.flag_fill,
            label: 'Resign',
            color: const Color(0xFFFF453A),
            onPressed: gameState.isGameOver ? null : _showResignDialog,
          ),

          // Move history button
          _buildIconButton(
            icon: CupertinoIcons.list_bullet,
            label: 'Moves',
            color: const Color(0xFF4A9DFF),
            onPressed: () => setState(() => _showMoveHistory = !_showMoveHistory),
          ),

          // Toggle visibility button
          _buildIconButton(
            icon: gameState.isPeeking
                ? CupertinoIcons.eye_slash_fill
                : CupertinoIcons.eye_fill,
            label: gameState.isPeeking ? 'Hide' : 'Show',
            color: gameState.isPeeking
                ? const Color(0xFFFF9F0A)
                : const Color(0xFF81b64c),
            onPressed: gameState.isGameOver
                ? null
                : () => context.read<GameState>().togglePieceVisibility(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isEnabled ? color.withOpacity(0.15) : Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isEnabled ? color.withOpacity(0.3) : Colors.grey[800]!,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: isEnabled ? color : Colors.grey[700],
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isEnabled ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoveHistorySheet(GameState gameState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Move History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => setState(() => _showMoveHistory = false),
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Colors.grey[600],
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Move history content
          Expanded(
            child: MoveHistory(),
          ),
        ],
      ),
    );
  }
}
