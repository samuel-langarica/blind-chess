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
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF312e2b),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF3d3a37), width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Move History',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _formatMoveHistory(gameState.moveHistory),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
