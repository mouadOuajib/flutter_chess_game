import 'package:chess_game/components/deadPiece.dart';
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
  //list of white pieces that have been taken
  List<ChessPiece> whitePiecesTaken = [];
  //list of black pieces that have been taken
  List<ChessPiece> blackPiecesTaken = [];


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
    newBoard[0][2] = const ChessPiece(type: ChessPieceType.bishop,imagePath: "assets/whitepieces/bishop.png",isWhite: false);
    newBoard[0][5] = const ChessPiece(type: ChessPieceType.bishop,imagePath: "assets/whitepieces/bishop.png",isWhite: false);
    newBoard[7][2] = const ChessPiece(type: ChessPieceType.bishop,imagePath: "assets/whitepieces/bishop.png",isWhite: true);
    newBoard[7][5] = const ChessPiece(type: ChessPieceType.bishop,imagePath: "assets/whitepieces/bishop.png",isWhite: true);
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
      if(selectedPiece == null && board[row][col] != null){
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }else if (board[row][col]!=null && board[row][col]!.isWhite == selectedPiece!.isWhite){
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      //if the user selected a piece and tap in squar that is a valid move the piece move there
      else if(selectedPiece != null && valideMoves.any((element) => element[0] == row && element[1]==col)){
        movePieces(row, col);
      }
    });
    valideMoves = checkValideMoves(selectedRow,selectedCol,selectedPiece);
  }
  late List<List<ChessPiece?>> board;

  List<List<int>> checkValideMoves(int row ,int col,ChessPiece? piece){
    List<List<int>> candidateMoves =  [];

    if(piece == null){
      return [];
    }
    int direction = piece.isWhite? -1:1;
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
        //horizontal and vertical directions
        var directions = [
          [-1,0]//up
          ,[1,0]//down
          ,[0,-1],//left
          [0,1]//right
        ];
        for(var direction in directions ){
          var i = 1;
          while(true){
            var newRow = row +i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol]!=null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow,newCol]);
              }
              break;
            }
            candidateMoves.add([newRow,newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1,0]
          ,[1,0]
          ,[0,-1],
          [0,1],
          [-1,-1]
          ,[-1,1]
          ,[1,-1],
          [1,1]
        ];
        
        for(var move in directions){
          var newRow = row +move[0];
          var newCol = col + move[1];
          if(!isInBoard(newRow, newCol)){
            continue;
          }
          if(board[newRow][newCol]!=null){
            if(board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow,newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow,newCol]);
        }
        break;
      case ChessPieceType.queen:
        var directions = [
          [-1,0]
          ,[1,0]
          ,[0,-1],
          [0,1],
          [-1,-1]
          ,[-1,1]
          ,[1,-1],
          [1,1]
        ];
        
        for(var move in directions){
          var i =1;
          while(true){
            var newRow = row +i* move[0];
            var newCol = col +i* move[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol]!=null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow,newCol]);
              }
              break;
            }
            candidateMoves.add([newRow,newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        //all eight move that the knight can do 
        var knightMoves = [
          [-2,-1]
          ,[-2,1]
          ,[-1,-2],
          [-1,2],
          [1,-2]
          ,[1,2]
          ,[2,-1],
          [2,1]
        ];
        for(var move in knightMoves){
          var newRow = row + move[0];
          var newCol = col + move[1];
          if(!isInBoard(newRow, newCol)){
            continue;
          }
          if(board[newRow][newCol]!=null){
            if(board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow,newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow,newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //diagonal directions
         var directions = [
          [-1,-1]
          ,[-1,1]
          ,[1,-1],
          [1,1]
        ];
        for (var direction in directions) {
    var i = 1;
    while (true) {
        var newRow = row + i * direction[0];
        var newCol = col + i * direction[1];
        if (!isInBoard(newRow, newCol)) {
            break;
        }
        if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
            }
            break;
        } else {
            candidateMoves.add([newRow, newCol]);
        }
        i++;
    }
}
        break;
    }

    return candidateMoves;
  }

  // ChessPiece pawn = const ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: "assets/whitepieces/pawn.png");
  
  void movePieces(int newRow,int newCol){
    //if the new spot has enemy on it 
    if(board[newRow][newCol]!=null){
      //add the taken piece to the list of death pieces
      var capturedpiece = board[newRow][newCol];
      if(capturedpiece!.isWhite){
        whitePiecesTaken.add(capturedpiece);
      }else{
        blackPiecesTaken.add(capturedpiece);
      }
    }
    //move the pices and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;
    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      valideMoves = [];
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Expanded(child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: whitePiecesTaken.length,
            itemBuilder: (BuildContext context, int index) {
              return DeadPiece(imagePath: whitePiecesTaken[index].imagePath, isWhite: whitePiecesTaken[index].isWhite);
            },
          ),),
          Expanded(
            flex: 3,
            child: GridView.builder(
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
          ),
          Expanded(child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            itemCount: blackPiecesTaken.length,
            itemBuilder: (BuildContext context, int index) {
              return DeadPiece(imagePath: blackPiecesTaken[index].imagePath, isWhite: blackPiecesTaken[index].isWhite);
            },
          ),),
        ],
      ),
    );
  }
}