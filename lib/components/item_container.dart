import 'dart:async';
import 'package:flame/components.dart';
import 'package:talacare/components/item.dart';

class ItemContainer extends RectangleComponent {
  @override
  FutureOr<void> onLoad() {
    add(Item());
    add(Item());
    add(Item());
    return super.onLoad();
  }
}