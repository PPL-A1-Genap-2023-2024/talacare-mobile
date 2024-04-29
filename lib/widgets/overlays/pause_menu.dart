import 'package:flutter/material.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/screens/homepage.dart';
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.baseColor,
              border: Border.all(color: AppColors.textColor, width: 8.0),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: DefaultTextStyle(
                        child: Center(child: Text('Game dijeda')),
                        style: AppTextStyles.h1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            IconButton(
                              key: _exitButtonKey,
                              icon:
                                  Image.asset('assets/images/Dialog/home.png'),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomePage();
                                }));
                              },
                            ),
                            const DefaultTextStyle(
                              child: Text('Keluar'),
                              style: AppTextStyles.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            IconButton(
                              key: _resumeButtonKey,
                              icon:
                                  Image.asset('assets/images/Dialog/okay.png'),
                              onPressed: () {
                                gameRef.resumeEngine();
                                gameRef.overlays.remove(PauseMenu.id);
                                gameRef.overlays.add(PauseButton.id);
                              },
                            ),
                            const DefaultTextStyle(
                              child: Text('Lanjut'),
                              style: AppTextStyles.normal,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
