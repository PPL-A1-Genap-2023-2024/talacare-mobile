import 'package:flutter/material.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double buttonWidth;
  final double buttonHeight = 72;
  final String? assetImagePath;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.buttonWidth,
      this.assetImagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Positioned(
                left: 9,
                top: 7,
                child: Container(
                  width: buttonWidth - 18,
                  height: buttonHeight - 27,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (assetImagePath != null)
                        (Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(assetImagePath!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                      if (assetImagePath != null) const SizedBox(width: 10),
                      Text(text,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.mediumBold),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: onPressed,
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
