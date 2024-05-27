import 'package:flutter/material.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/helpers/audio_manager.dart';

enum ButtonSize { mini, small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonSize size;
  final String? assetImagePath;
  final bool isTesting;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.assetImagePath,
    this.isTesting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonWidth;
    double buttonHeight = 72;

    switch (size) {
      case ButtonSize.mini:
        buttonWidth = 95;
        break;
      case ButtonSize.small:
        buttonWidth = 150;
        break;
      case ButtonSize.medium:
        buttonWidth = 200;
        break;
      case ButtonSize.large:
        buttonWidth = 270;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: buttonWidth,
          height: buttonHeight,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: buttonWidth,
                  height: 72,
                  decoration: ShapeDecoration(
                    color: AppColors.plum,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 7,
                child: Container(
                  width: buttonWidth - 18,
                  height: buttonHeight - 19,
                  decoration: ShapeDecoration(
                    color: Color(0xFFE5C8B6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 9,
                top: 7,
                child: Container(
                  width: buttonWidth - 18,
                  height: buttonHeight - 27,
                  decoration: ShapeDecoration(
                    color: AppColors.baseColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: Offset(0, -6),
                  child: Container(
                    width: buttonWidth - 18,
                    height: buttonHeight - 27,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (assetImagePath != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0),
                            child: (Container(
                              key: Key('icon_container'),
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(assetImagePath!),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )),
                          ),
                        Expanded(
                          child: Text(text,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.mediumBold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () async {
                      if(!isTesting){
                        await AudioManager.getInstance().playSoundEffect();
                      }
                      onPressed();
                    }
                    // onTap: onPressed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
