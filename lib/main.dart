import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'blank_game.dart';
import 'widgets/overlays/d_pad.dart';
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
              initialActiveOverlays: const [
                DPadButton.ID
              ],
              overlayBuilderMap: {
                DPadButton.ID: (BuildContext context, BlankGame gameRef) =>
                    DPadButton(onPressed: gameRef.onDirectionChanged)
              },
            ),
          ],
        ),
      ),
    ),
  );
}