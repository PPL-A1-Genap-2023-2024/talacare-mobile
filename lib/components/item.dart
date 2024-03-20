import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Item extends RectangleComponent {
  final paint = BasicPalette.purple.paint();

  Item({super.position, super.size});
}