import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class MoveHistory extends StatelessWidget {
  const MoveHistory({super.key});

  String _formatMoveHistory(List<String> moves) {
    if (moves.isEmpty) return 'No moves yet';

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < moves.length; i += 2) {
      final moveNumber = (i ~/ 2) + 1;
      final whiteMove = moves[i];
      final blackMove = i + 1 < moves.length ? moves[i + 1] : '';

      buffer.write('$moveNumber. $whiteMove');
      if (blackMove.isNotEmpty) {
        buffer.write(' $blackMove');
      }
      buffer.write('\n');
    }

    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final moves = gameState.moveHistory;
        if (moves.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_esports_outlined,
                  size: 64,
                  color: Colors.grey[700],
                ),
                const SizedBox(height: 16),
                Text(
                  'No moves yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Make your first move to begin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: (moves.length / 2).ceil(),
          itemBuilder: (context, index) {
            final moveNumber = index + 1;
            final whiteMove = moves[index * 2];
            final blackMove = index * 2 + 1 < moves.length
                ? moves[index * 2 + 1]
                : null;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // Move number
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$moveNumber.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  // White move
                  Expanded(
                    child: Text(
                      whiteMove,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),

                  // Black move
                  if (blackMove != null)
                    Expanded(
                      child: Text(
                        blackMove,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
