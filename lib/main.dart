import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'blank_game.dart';
void main() {
  final game = BlankGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: game,
            ),
          ],
        ),
      ),
    ),
  );
}