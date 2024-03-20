import 'package:flame/components.dart';
import 'package:flame/palette.dart';

class Item extends RectangleComponent {
  @override
  final paint = BasicPalette.purple.paint();

  Item({super.position, super.size});
}