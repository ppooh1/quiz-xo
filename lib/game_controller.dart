import 'dart:math';

enum Player { X, O, None }
List lastmove = [];
List redo_ = []  ;
class GameBoard {
  
  late List<List<Player>> board;

  GameBoard() {
    resetBoard();
  }

  void resetBoard() {
    board = List.generate(3, (_) => List.generate(3, (_) => Player.None));
  }
  
  Player getPlayer(int row, int col) {
    
    return board[row][col];
    
  }

  void setPlayer(int row, int col, Player player) {
  
    if (board[row][col] == Player.None) {
      board[row][col] = player;
      if (board[row][col] == Player.O){
        lastmove.add(row);
        lastmove.add(col);
      }
      if (board[row][col] == Player.X){
        lastmove.add(row);
        lastmove.add(col);
      }

    }
  }

  bool isFull() {
    return board.every((row) => row.every((cell) => cell != Player.None));
  }
}

class GameController {

  late GameBoard board;

  Player currentPlayer = Player.X;
  Player winner = Player.None;

  GameController() {
    board = GameBoard();
    currentPlayer; // Default starting player
    winner;
  }

  void randomizeStartingPlayer() {
    var random = Random();
    currentPlayer = random.nextBool() ? Player.X : Player.O;
  }
  void undo(){
  if (!board.isFull()){
    if(lastmove.isNotEmpty){
      
      int col = lastmove.removeLast();
      int row = lastmove.removeLast();
      redo_.add(row);
      redo_.add(col);
      board.board[row][col] = Player.None;
      currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;

    }
  
  }
}
  void redo(){
    if (!board.isFull()){
      if(redo_.isNotEmpty){
        int col = redo_.removeLast();
        int row = redo_.removeLast();
        lastmove.add(row);  
        lastmove.add(col);
        board.board[row][col] = currentPlayer;
        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;
      }
    }
  }
  
  void playTurn(int row, int col) {
    if (board.getPlayer(row, col) == Player.None && winner == Player.None) {
      

      board.setPlayer(row, col, currentPlayer);
      
      

      
      
      if (checkWinner(row, col)) {
        winner = currentPlayer;
      } else {
        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;

      }
    }
  }
  void checkBoard(int row, int col){
    if (board.board[row][0]== currentPlayer &&
        board.board[row][1]== currentPlayer){
          board.board[row][0] = Player.None;
          board.board[row][1] = Player.None;
          
        }
    if (board.board[row][2]== currentPlayer &&
        board.board[row][1]== currentPlayer){
          board.board[row][2] = Player.None;
          board.board[row][1] = Player.None;
        }
    if (board.board[0][col]== currentPlayer &&
        board.board[1][col]== currentPlayer){
          board.board[0][col] = Player.None;
          board.board[1][col] = Player.None;
        }
    if (board.board[2][col]== currentPlayer &&
        board.board[1][col]== currentPlayer){
          board.board[2][col] = Player.None;
          board.board[1][col] = Player.None;
        }
  }
  
  bool checkWinner(int row, int col) {
    // Check row
    if (board.board[row][0] == currentPlayer &&
        board.board[row][1] == currentPlayer &&
        board.board[row][2] == currentPlayer) {
      return true;
    }
    
    // Check column
    if (board.board[0][col] == currentPlayer &&
        board.board[1][col] == currentPlayer &&
        board.board[2][col] == currentPlayer) {
      return true;
    }

    // Check diagonal
    if (row == col) {
      // Top-left to bottom-right
      if (board.board[0][0] == currentPlayer &&
          board.board[1][1] == currentPlayer &&
          board.board[2][2] == currentPlayer) {
        return true;
      }
    }

    if (row + col == 2) {
      // Top-right to bottom-left
      if (board.board[0][2] == currentPlayer &&
          board.board[1][1] == currentPlayer &&
          board.board[2][0] == currentPlayer) {
        return true;
      }
    }

    return false;
  }
  bool get isGameOver {
    return winner != Player.None || board.isFull();
  }

  void resetGame() {
    board.resetBoard();
    currentPlayer = Player.X;
    winner = Player.None;
  }
}