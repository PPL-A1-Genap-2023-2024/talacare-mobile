import 'package:flutter/material.dart';
import '../../helpers/directions.dart';

class DPadButton extends StatefulWidget {
  static const String ID = 'DirectionPad';
  final Function(Direction) onPressed;

  const DPadButton({super.key, required this.onPressed});

  @override
  _DPadButtonState createState() => _DPadButtonState();
}

class _DPadButtonState extends State<DPadButton> {
  late Direction _currentDirection;

  @override
  void initState() {
    super.initState();
    _currentDirection = Direction.none;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.05, // Adjust the factor as needed
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/D-Pad.png')
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  key: const Key("Up"),
                  onTapDown: (_) {
                    _updateDirection(Direction.up);
                  },
                  onTapUp: (_) {
                    _updateDirection(Direction.none);
                  },
                  onTapCancel: () {
                    _updateDirection(Direction.none);
                  },
                  child: Image.asset(
                    _currentDirection == Direction.up
                        ? 'assets/images/Up-Pressed.png'
                        : 'assets/images/Up.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  key: const Key("Left"),
                  onTapDown: (_) {
                    _updateDirection(Direction.left);
                  },
                  onTapUp: (_) {
                    _updateDirection(Direction.none);
                  },
                  onTapCancel: () {
                    _updateDirection(Direction.none);
                  },
                  child: Image.asset(
                    _currentDirection == Direction.left
                        ? 'assets/images/Left-Pressed.png'
                        : 'assets/images/Left.png',
                  ),
                ),
                const SizedBox(width: 50),
                GestureDetector(
                  key: const Key("Right"),
                  onTapDown: (_) {
                    _updateDirection(Direction.right);
                  },
                  onTapUp: (_) {
                    _updateDirection(Direction.none);
                  },
                  onTapCancel: () {
                    _updateDirection(Direction.none);
                  },
                  child: Image.asset(
                    _currentDirection == Direction.right
                        ? 'assets/images/Right-Pressed.png'
                        : 'assets/images/Right.png',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  key: const Key("Down"),
                  onTapDown: (_) {
                    _updateDirection(Direction.down);
                  },
                  onTapUp: (_) {
                    _updateDirection(Direction.none);
                  },
                  onTapCancel: () {
                    _updateDirection(Direction.none);
                  },
                  child: Image.asset(
                    _currentDirection == Direction.down
                        ? 'assets/images/Down-Pressed.png'
                        : 'assets/images/Down.png',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateDirection(Direction direction) {
    setState(() {
      _currentDirection = direction;
    });

    widget.onPressed(direction);
  }
}
