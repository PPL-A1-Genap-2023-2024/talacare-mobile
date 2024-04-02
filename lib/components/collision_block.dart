import 'package:flame/components.dart';

enum WallTypes { outerLeft, outerRight, outerTop, outerBottom, inside }
class CollisionBlock extends PositionComponent {
  WallTypes type;

  CollisionBlock({ super.position, super.size, this.type = WallTypes.inside }) ;
}