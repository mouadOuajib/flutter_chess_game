import 'package:chess_game/components/pieces.dart';
import 'package:chess_game/values/colors/colors.dart';
import 'package:flutter/material.dart';

class Squar extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Squar({super.key,required this.isWhite,required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      color: isWhite? backgroundColor:foregroundColor,
      child: piece != null ? Center(child: SizedBox(
        height: 30,
        child: Image.asset(piece!.imagePath,color: piece!.isWhite? Colors.white:Colors.black,))):null,
    );
  }
}