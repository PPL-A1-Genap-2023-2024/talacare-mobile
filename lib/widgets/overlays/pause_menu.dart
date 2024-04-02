import 'package:flutter/material.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/homepage.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';

class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final TalaCare gameRef;
  final GlobalKey _exitButtonKey = GlobalKey();
  final GlobalKey _resumeButtonKey = GlobalKey();
  PauseMenu({super.key, required this.gameRef});

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
                height: MediaQuery.of(context).size.height * 55 / 100,
                width: MediaQuery.of(context).size.width * 70 / 100,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 25, bottom: 25),
                        child: Text(
                          'Game dijeda',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        )),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                      ),
                      height: MediaQuery.of(context).size.height * 20 / 100,
                      width: MediaQuery.of(context).size.width * 40 / 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              IconButton(
                                key: _exitButtonKey,
                                iconSize: 60,
                                splashColor: Colors.white,
                                icon: const Icon(Icons.house),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context){
                                        return HomePage();
                                      })
                                  );
                                },
                              ),
                              const Text(
                                'Keluar',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              IconButton(
                                key: _resumeButtonKey,
                                iconSize: 60,
                                splashColor: Colors.white,
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  gameRef.resumeEngine();
                                  gameRef.overlays.remove(PauseMenu.id);
                                  gameRef.overlays.add(PauseButton.id);
                                },
                              ),
                              const Text(
                                'Lanjut',
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
