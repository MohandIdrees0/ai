import 'dart:io';
import 'dart:math';
class TicTacToe {
  int humanScore=0;
  int AiScore=0;
  int round=0;
  bool isAi = Random().nextBool();
  List<List<int>> board = List.generate(3, (_) => List.generate(3, (_) => 0));
  TicTacToe(){
    if(isAi){
      getBestMove();
    }
  }
  void displayBoard() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        stdout.write(board[i][j] == 1 ? ' X ' : (board[i][j] == -1 ? ' O ' : ' - '));
      }
      print('');
    }
    print('');
  }
  bool makeMove(int row, int col, bool isAI) {
    if (board[row][col] == 0) {
      board[row][col] = isAI ? 1 : -1;
      return true;
    }
    return false;
  }
  List isWinner(bool isAI) {
    for (int i = 0; i < 3; i++) {
      if ((board[0][i] + board[1][i] + board[2][i] == (isAI ? 3 : -3))) {
        return [[0,i],[1,i],[2,i]];
      }
      if ((board[i][0] + board[i][1] + board[i][2] == (isAI ? 3 : -3))){
        return [[i,0],[i,1],[i,2]];
      }
    }
    if ((board[0][2] + board[1][1] + board[2][0] == (isAI ? 3 : -3))) {
      return [[0,2],[1,1],[2,0]];
    }
    if ((board[0][0] + board[1][1] + board[2][2] == (isAI ? 3 : -3))){
      return [[0,0],[1,1],[2,2]];
    }

    return [];
  }

  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == 0) {
          return false;
        }
      }
    }
    return true;
  }

  int minimax(bool isAI) {
    if (isWinner(true).isNotEmpty) {
      return 1;
    } else if (isWinner(false).isNotEmpty) {
      return -1;
    } else if (isBoardFull()) {
      return 0;
    }

    int bestScore = isAI ? -1 : 1;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == 0) {
          board[i][j]= isAI ? 1 : -1;
          int score = minimax(!isAI);
          board[i][j] = 0;
          if (isAI) {
            bestScore = score > bestScore ? score : bestScore;
          } else {
            bestScore = score < bestScore ? score : bestScore;
          }
        }
      }
    }

    return bestScore;
  }

  void getBestMove() {
    int bestScore = -1;
    List<int> bestMove = [-1, -1];

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == 0) {
          board[i][j] = 1;
          int score = minimax(false);
          board[i][j] = 0;
          if (score > bestScore) {
            bestScore = score;
            bestMove = [i, j];
          }
        }
      }
    }
    board[bestMove[0]][bestMove[1]]=1;
  }
  bool check(bool isAi){
    return isWinner(isAi).isNotEmpty || isBoardFull();
  }
  List handlefinish(bool isAi){
    List track=[];
    if(isAi && isWinner(isAi).isNotEmpty){
      AiScore++;
      track=isWinner(isAi);
    }
    else if(!isAi && isWinner(isAi).isNotEmpty){
      humanScore++;
      track=isWinner(isAi);
    }
    round+=1;
    return track;
  }
  void nextGame(){
    board=List.generate(3, (_) => List.generate(3, (_) => 0));
    isAi=!isAi;
    if(isAi){
      getBestMove();
    }
  }
}