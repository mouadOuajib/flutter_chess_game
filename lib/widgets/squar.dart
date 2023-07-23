import 'package:chess_game/components/pieces.dart';
import 'package:chess_game/values/colors/colors.dart';
import 'package:flutter/material.dart';

class Squar extends StatelessWidget {
  final bool isWhite;
  final bool isSelected;
  final bool isValideMove;
  final ChessPiece? piece;
  final void Function() ontap;
  const Squar({super.key,required this.isWhite,required this.piece,required this.isSelected,required this.ontap,required this.isValideMove});

  @override
  Widget build(BuildContext context) {
    Color? squarColor;

    if(isSelected){
      squarColor =Colors.redAccent;
    }else if (isValideMove){
      squarColor == Colors.red;
    }else{
      squarColor = isWhite? foregroundColor:backgroundColor;
    }
    return InkWell(
      onTap: ontap,
      child: Container(
        height: MediaQuery.of(context).size.height*0.5,
        color: squarColor,
        child: piece != null ? Center(child: SizedBox(
          height: 30,
          child: Image.asset(piece!.imagePath,color: piece!.isWhite? Colors.white:Colors.black,))):null,
      ),
    );
  }
}