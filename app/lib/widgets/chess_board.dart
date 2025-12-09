import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chess/chess.dart' as chess_lib;
import '../models/game_state.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

  static const files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  static const ranks = ['8', '7', '6', '5', '4', '3', '2', '1'];

  static const lightSquareColor = Color(0xFFF0D9B5);
  static const darkSquareColor = Color(0xFFB58863);
  static const selectedSquareColor = Color(0xFF9BC1E8);
  static const lastMoveColor = Color(0xFFCDD26A);

  String _getSquareName(int fileIndex, int rankIndex) {
    return '${files[fileIndex]}${ranks[rankIndex]}';
  }

  bool _isLightSquare(int fileIndex, int rankIndex) {
    return (fileIndex + rankIndex) % 2 == 0;
  }

  String _getPieceSymbol(chess_lib.Piece piece) {
    final isWhite = piece.color == chess_lib.Color.WHITE;
    final typeStr = piece.type.toString();

    if (typeStr.contains('k')) {
      return isWhite ? '♔' : '♚';
    } else if (typeStr.contains('q')) {
      return isWhite ? '♕' : '♛';
    } else if (typeStr.contains('r')) {
      return isWhite ? '♖' : '♜';
    } else if (typeStr.contains('b')) {
      return isWhite ? '♗' : '♝';
    } else if (typeStr.contains('n')) {
      return isWhite ? '♘' : '♞';
    } else if (typeStr.contains('p')) {
      return isWhite ? '♙' : '♟';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              children: [
                // Rank 8 to 1
                for (int rankIndex = 0; rankIndex < 8; rankIndex++)
                  Expanded(
                    child: Row(
                      children: [
                        // Rank label on left
                        SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              ranks[rankIndex],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        // Files a-h
                        for (int fileIndex = 0; fileIndex < 8; fileIndex++)
                          Expanded(
                            child: _buildSquare(
                              context,
                              gameState,
                              fileIndex,
                              rankIndex,
                            ),
                          ),
                        // Rank label on right
                        SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              ranks[rankIndex],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // File labels at bottom
                Row(
                  children: [
                    const SizedBox(width: 20),
                    for (int fileIndex = 0; fileIndex < 8; fileIndex++)
                      Expanded(
                        child: Center(
                          child: Text(
                            files[fileIndex],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSquare(
    BuildContext context,
    GameState gameState,
    int fileIndex,
    int rankIndex,
  ) {
    final squareName = _getSquareName(fileIndex, rankIndex);
    final isLight = _isLightSquare(fileIndex, rankIndex);
    final isSelected = gameState.selectedSquare == squareName;
    final piece = gameState.chess.get(squareName);

    Color squareColor;
    if (isSelected) {
      squareColor = selectedSquareColor;
    } else if (isLight) {
      squareColor = lightSquareColor;
    } else {
      squareColor = darkSquareColor;
    }

    return GestureDetector(
      onTap: () => _handleSquareTap(context, gameState, squareName),
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Center(
          child: gameState.isPeeking && piece != null
              ? Text(
                  _getPieceSymbol(piece),
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _handleSquareTap(
    BuildContext context,
    GameState gameState,
    String square,
  ) {
    if (gameState.isGameOver) return;

    if (gameState.selectedSquare == null) {
      // First tap - select piece
      final piece = gameState.chess.get(square);
      if (piece != null && piece.color == gameState.chess.turn) {
        gameState.selectSquare(square);
      } else {
        // Show feedback for invalid selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              piece == null
                  ? 'No piece at $square'
                  : 'Not your piece',
            ),
            duration: const Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      // Second tap - try to move
      final from = gameState.selectedSquare!;
      final success = gameState.attemptMove(from, square);

      if (!success) {
        // Show feedback for illegal move
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Illegal move - streak reset!'),
            duration: Duration(milliseconds: 800),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
