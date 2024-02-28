import 'package:flutter/material.dart';
import 'package:talacare/main.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final CollidableAnimationExample gameRef;
  final GlobalKey _exitButtonKey = GlobalKey();
  final GlobalKey _resumeButtonKey = GlobalKey();
  PauseMenu({super.key, required this.gameRef});

  GlobalKey getExitButtonKey() {
    return _exitButtonKey;
  }

  GlobalKey getResumeButtonKey() {
    return _resumeButtonKey;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
              opacity: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.white),
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                height: MediaQuery.of(context).size.height * 60 / 100,
                width: MediaQuery.of(context).size.width * 80 / 100,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 35, bottom: 35),
                        child: Text(
                          'Game is Paused',
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.black,
                          ),
                        )),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                      ),
                      height: MediaQuery.of(context).size.height * 25 / 100,
                      width: MediaQuery.of(context).size.width * 50 / 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              IconButton(
                                key: _exitButtonKey,
                                iconSize: 70,
                                splashColor: Colors.white,
                                icon: const Icon(Icons.house),
                                onPressed: () {},
                              ),
                              const Text(
                                'Exit',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              IconButton(
                                key: _resumeButtonKey,
                                iconSize: 70,
                                splashColor: Colors.white,
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  gameRef.resumeEngine();
                                  gameRef.overlays.remove(PauseMenu.id);
                                  gameRef.overlays.add(PauseButton.id);
                                },
                              ),
                              const Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
