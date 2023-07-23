import 'package:chess_game/components/pieces.dart';
import 'package:chess_game/helper/helper_methodes.dart';
import 'package:chess_game/widgets/squar.dart';
import 'package:flutter/material.dart';

class ChessGame extends StatefulWidget {
  const ChessGame({super.key});

  @override
  State<ChessGame> createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {
  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }  

  ChessPiece? selectedPiece ;
  int selectedRow = -1;
  int selectedCol =-1;
  List<List<int>> valideMoves = [];


  void _initializeBoard(){

    List<List<ChessPiece?>> newBoard = List.generate(8, (index) => List<ChessPiece?>.filled(8, null));
    //place pawn
    for(int i=0; i<8;i++){
      newBoard[1][i]= const ChessPiece(type: ChessPieceType.pawn, isWhite: false, imagePath: "assets/whitepieces/pawn.png");
      newBoard[6][i]= const ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: "assets/whitepieces/pawn.png");
    }
    //place rooks 
    newBoard[0][0] = const ChessPiece(type: ChessPieceType.rook,imagePath: "assets/whitepieces/rook.png",isWhite: false);
    newBoard[0][7] = const ChessPiece(type: ChessPieceType.rook,imagePath: "assets/whitepieces/rook.png",isWhite: false);
    newBoard[7][0] = const ChessPiece(type: ChessPieceType.rook,imagePath: "assets/whitepieces/rook.png",isWhite: true);
    newBoard[7][7] = const ChessPiece(type: ChessPieceType.rook,imagePath: "assets/whitepieces/rook.png",isWhite: true);
    //place knights
    newBoard[0][1] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/knight.png",isWhite: false);
    newBoard[0][6] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/knight.png",isWhite: false);
    newBoard[7][1] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/knight.png",isWhite: true);
    newBoard[7][6] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/knight.png",isWhite: true);
    //place bishop
    newBoard[0][2] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/bishop.png",isWhite: false);
    newBoard[0][5] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/bishop.png",isWhite: false);
    newBoard[7][2] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/bishop.png",isWhite: true);
    newBoard[7][5] = const ChessPiece(type: ChessPieceType.knight,imagePath: "assets/whitepieces/bishop.png",isWhite: true);
    //place queen
    newBoard[0][3] = const ChessPiece(type: ChessPieceType.queen,imagePath: "assets/whitepieces/queen.png",isWhite: false);
    newBoard[7][3] = const ChessPiece(type: ChessPieceType.queen,imagePath: "assets/whitepieces/queen.png",isWhite: true);
    //place king
    newBoard[0][4] = const ChessPiece(type: ChessPieceType.king,imagePath: "assets/whitepieces/king.png",isWhite: false);
    newBoard[7][4] = const ChessPiece(type: ChessPieceType.king,imagePath: "assets/whitepieces/king.png",isWhite: true);

    board = newBoard;
  }
  //user selected a piece
  void pieceSelected(int row ,int col){
    setState(() {
      if(board[row][col]!=null){
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    });
    valideMoves = checkValideMoves(selectedRow,selectedCol,selectedPiece);
  }
  late List<List<ChessPiece?>> board;

  List<List<int>> checkValideMoves(int row ,int col,ChessPiece? piece){
    List<List<int>> candidateMoves =  [];
    int direction = piece!.isWhite? -1:1;

    switch(piece.type){
      case ChessPieceType.pawn:
        //pawn can move forward if the sqaur is not accupied
        if(isInBoard(row + direction, col)&& board[row+direction][col]== null){
          candidateMoves.add([row+direction,col]);
        }
        //pawn can move two position if he is in the initial position
        if((row ==1 && !piece.isWhite)||(row ==6 && piece.isWhite)){
          if(isInBoard(row+2*direction, col)&&board[row+2*direction][col]==null && board[row+direction][col]==null){
            candidateMoves.add([row+2*direction,col]);
          }
        }
        //pawn can kill diagonally
        if(isInBoard(row+direction, col -1)&& board[row+direction][col-1]!=null&& board[row+direction][col-1]!.isWhite){
          candidateMoves.add([row+direction,col-1]);
        }
        if(isInBoard(row+direction, col +1)&& board[row+direction][col+1]!=null&& board[row+direction][col+1]!.isWhite){
          candidateMoves.add([row+direction,col+1]);
        }
        break;
      case ChessPieceType.rook:
        break;
      case ChessPieceType.king:
        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.knight:
        break;
      case ChessPieceType.bishop:
        break;
    }

    return candidateMoves;
  }

  // ChessPiece pawn = const ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: "assets/whitepieces/pawn.png");

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemCount: 8*8,
        itemBuilder: (BuildContext context, int index) {
          int row = index ~/8;
          int col = index % 8;
          bool isSelected = selectedRow == row && selectedCol == col;
          bool isValide = false;
          for(var position in valideMoves){
            if(position[0]==row&&position[1]==col){
              isValide = true;
            }
          }

          return Squar(isWhite: isWhite(index),piece: board[row][col],isSelected: isSelected,ontap: ()=> pieceSelected(row, col),isValideMove: isValide,);
        },
      ),
    );
  }
}