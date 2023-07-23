enum ChessPieceType {pawn,rook,bishop,knight,king,queen}

class ChessPiece{
  final ChessPieceType type;
  final String imagePath;
  final bool isWhite;
  const ChessPiece({required this.type,required this.isWhite,required this.imagePath});
}