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
    _initializeboard();
  }

  void _initializeboard(){}
  late List<List<ChessPiece>> board;

  ChessPiece pawn = const ChessPiece(type: ChessPieceType.pawn, isWhite: true, imagePath: "assets/whitepieces/pawn.png");

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
          return Squar(isWhite: isWhite(index),piece: pawn,);
        },
      ),
    );
  }
}