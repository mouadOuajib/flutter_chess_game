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
  //bool the indicate whose turn is it
  bool isWhiteTurn = true;
  //track the positon of the king to make it easier to see if do king is in check
  List<int> whiteKingPosition = [7,4];
  List<int> blackKingPosition = [0,4];
  bool checkStatus = false;




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
        if(board[row][col]!.isWhite == isWhiteTurn){
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
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
    valideMoves = checkRealValideMoves(selectedRow,selectedCol,selectedPiece,true);
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
        // Pawn can kill diagonally (white and black)
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
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



  //calculate real valide moves
  List<List<int>> checkRealValideMoves (int row,int col,ChessPiece? piece,bool checkSimulation){
    List<List<int>> realValidMoves = [];
    List<List<int>> candidatMoves= checkValideMoves(row, col, piece,);
    if(checkSimulation){
      for(var move in candidatMoves){
        int endRow = move[0];
        int endCol = move[1];
        if(simulatedMoveIsSafe(piece!,row,col,endRow,endCol)){
           realValidMoves.add(move);
        }
      }
    }else{
      realValidMoves = candidatMoves;
    }

    return realValidMoves;
  }


  
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
    //check if the piece being moved is a king 
    if(selectedPiece!.type == ChessPieceType.king){
       //update the approtiate king position
       if(selectedPiece!.isWhite){
        whiteKingPosition =[newRow,newCol];
       }else{
        blackKingPosition = [newRow,newCol];
       }
    }

    //move the pices and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //see if any kings are under attack

    if(kingIsInCheck(!isWhiteTurn)){
      checkStatus = true;
    }else{
      checkStatus = false;
    }

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      valideMoves = [];
    });
    //check if it's check mate
    if(isCheckMate(!isWhiteTurn)){
      showDialog(context: context, builder: (context)=>  AlertDialog(
        title:  const Text("Check Mate !"),
        actions: [
          TextButton(onPressed: resetGame, child:const  Center(child: Text("play again"),))
        ],
      ));
    }
    //switch turns
    isWhiteTurn = !isWhiteTurn;
  }



  //is king in check
  bool kingIsInCheck(bool isWhiteKing) {
  // Get the position of the king
  List<int> kingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;

    // Check if any enemy piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // Skip empty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> piecesValidMoves = checkRealValideMoves(i, j, board[i][j],false);
        // Check if the king's position is in any of these valid moves
        if (piecesValidMoves.any((move) => move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true; // King is in check
        }
      }
    }
    
    return false; // King is not in check
  }




  //simulate future move to see if it's safe(dosn't put our king under attack)
  bool simulatedMoveIsSafe(ChessPiece piece, int startRow,int startCol,int endRow,int endCol){
    //save the current board state
    ChessPiece? originalDestinationPiece = board[endRow][endCol];
    //if the piece is the king we gonna save the current position and update to the new one 
    List<int>? originalKingPosition;
    if(piece.type == ChessPieceType.king){
      originalKingPosition = piece.isWhite?whiteKingPosition:blackKingPosition;
      if(piece.isWhite){
        whiteKingPosition =[endRow,startCol];
      }else{
        blackKingPosition = [endRow,endCol];
      }
    }
    //simulate the move
    board[endRow][endCol]=piece;
    board[startRow][startCol] = null;
    //check if the king is under attack
    bool kingInCheck = kingIsInCheck(piece.isWhite);
    //restore back to the original state
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPiece;
    //if the piece is the king restore it to original position
    if(piece.type == ChessPieceType.king){
      if(piece.isWhite){
        whiteKingPosition = originalKingPosition!;
      }else{
        blackKingPosition = originalKingPosition!;
      }
    }
    //if the king is in check return true, mean the move isn't safe
    return !kingInCheck;
  }


  //is it check mate (finish the game or still)
  bool isCheckMate(bool isWhiteKing){
    //check if the king is in check
    if(!kingIsInCheck(isWhiteKing)){
      return false;
    }
    //if there is at least one legal move of the player's pieces then it's not checkMate
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        //skip empty squars and oposite colors pieces
        if(board[i][j]==null || board[i][j]!.isWhite != isWhiteKing){
          continue;
        }
        List<List<int>> piecesValidMoves = checkRealValideMoves(i, j, board[i][j], true);
        //if there is any valide move then it not check mate 
        if(piecesValidMoves.isNotEmpty){
          return false;
        }
      }
    }
    return true;
  } 




  //reset game 
  void resetGame(){
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7,4];
    blackKingPosition = [0,4];
    setState(() {});
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
          //check test
          Text(checkStatus? "Check mate ...":""),
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
          Text(checkStatus? "Check mate ...":""),
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