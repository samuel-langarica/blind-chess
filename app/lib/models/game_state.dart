import 'package:chess/chess.dart' as chess_lib;
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  late chess_lib.Chess _chess;
  List<String> _moveHistory = [];
  int _consecutiveLegalMoves = 0;
  int _personalBest = 0;
  int _illegalAttempts = 0;
  String? _selectedSquare;
  bool _isPeeking = false;
  bool _isGameOver = false;
  String? _gameResult;
  String? _lastMoveFrom;
  String? _lastMoveTo;

  GameState() {
    _chess = chess_lib.Chess();
  }

  // Getters
  chess_lib.Chess get chess => _chess;
  List<String> get moveHistory => _moveHistory;
  int get consecutiveLegalMoves => _consecutiveLegalMoves;
  int get personalBest => _personalBest;
  int get illegalAttempts => _illegalAttempts;
  String? get selectedSquare => _selectedSquare;
  bool get isPeeking => _isPeeking;
  bool get isGameOver => _isGameOver;
  String? get gameResult => _gameResult;
  bool get isWhiteTurn => _chess.turn == chess_lib.Color.WHITE;
  String? get lastMoveFrom => _lastMoveFrom;
  String? get lastMoveTo => _lastMoveTo;

  void setPersonalBest(int best) {
    _personalBest = best;
    notifyListeners();
  }

  void selectSquare(String square) {
    _selectedSquare = square;
    notifyListeners();
  }

  void clearSelection() {
    _selectedSquare = null;
    notifyListeners();
  }

  bool attemptMove(String from, String to) {
    // Check if it's a valid square selection
    final piece = _chess.get(from);

    // If no piece at source, it's invalid
    if (piece == null) {
      _illegalAttempts++;
      notifyListeners();
      return false;
    }

    // If wrong color piece, it's invalid
    if (piece.color != _chess.turn) {
      _illegalAttempts++;
      notifyListeners();
      return false;
    }

    // Find the SAN notation for this move before making it
    final moves = _chess.moves({'verbose': true});
    String? sanNotation;

    for (final move in moves) {
      if (move['from'] == from && move['to'] == to) {
        sanNotation = move['san'] as String?;
        break;
      }
    }

    // Try to make the move
    final success = _chess.move({'from': from, 'to': to});

    if (!success) {
      // Illegal move - reset streak
      _consecutiveLegalMoves = 0;
      _illegalAttempts++;
      notifyListeners();
      return false;
    }

    // Legal move - increment streak
    _consecutiveLegalMoves++;
    if (_consecutiveLegalMoves > _personalBest) {
      _personalBest = _consecutiveLegalMoves;
    }

    // Add the SAN notation to history
    if (sanNotation != null) {
      _moveHistory.add(sanNotation);
    }

    // Track last move for highlighting
    _lastMoveFrom = from;
    _lastMoveTo = to;
    _selectedSquare = null;

    // Check for game over
    if (_chess.game_over) {
      _isGameOver = true;
      if (_chess.in_checkmate) {
        _gameResult = _chess.turn == chess_lib.Color.WHITE
            ? 'Checkmate - Black wins!'
            : 'Checkmate - White wins!';
      } else if (_chess.in_stalemate) {
        _gameResult = 'Stalemate - Draw!';
      } else if (_chess.in_draw) {
        _gameResult = 'Draw!';
      } else if (_chess.in_threefold_repetition) {
        _gameResult = 'Draw by repetition!';
      } else if (_chess.insufficient_material) {
        _gameResult = 'Draw - Insufficient material!';
      }
    } else {
      // AI makes a move if it's black's turn
      if (_chess.turn == chess_lib.Color.BLACK) {
        _makeAiMove();
      }
    }

    notifyListeners();
    return true;
  }

  void _makeAiMove() {
    // Simple random AI - picks a random legal move
    final moves = _chess.moves({'verbose': true});
    if (moves.isEmpty) return;

    // For now, just pick a random move
    // In the future, we can integrate Stockfish here
    moves.shuffle();
    final selectedMove = moves.first;

    final success = _chess.move(selectedMove);

    if (success) {
      // Add the SAN notation to history
      final sanNotation = selectedMove['san'] as String?;
      if (sanNotation != null) {
        _moveHistory.add(sanNotation);
      }

      // Track last move for highlighting
      _lastMoveFrom = selectedMove['from'] as String?;
      _lastMoveTo = selectedMove['to'] as String?;

      // Check for game over after AI move
      if (_chess.game_over) {
        _isGameOver = true;
        if (_chess.in_checkmate) {
          _gameResult = _chess.turn == chess_lib.Color.WHITE
              ? 'Checkmate - Black wins!'
              : 'Checkmate - White wins!';
        } else if (_chess.in_stalemate) {
          _gameResult = 'Stalemate - Draw!';
        } else if (_chess.in_draw) {
          _gameResult = 'Draw!';
        }
      }
    }
  }

  void togglePieceVisibility() {
    _isPeeking = !_isPeeking;
    notifyListeners();
  }

  void newGame() {
    _chess = chess_lib.Chess();
    _moveHistory = [];
    _consecutiveLegalMoves = 0;
    _illegalAttempts = 0;
    _selectedSquare = null;
    _isPeeking = false;
    _isGameOver = false;
    _gameResult = null;
    _lastMoveFrom = null;
    _lastMoveTo = null;
    notifyListeners();
  }

  void resign() {
    _isGameOver = true;
    _gameResult = 'You resigned - Black wins!';
    notifyListeners();
  }
}
