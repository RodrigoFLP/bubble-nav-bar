import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BottomBar extends CustomPainter {
  double yTraslation;
  double yBubbleTraslation;
  int selectedIcon;
  double iconScale;
  double barPaddingIn;
  double barPaddingOut;
  double isprinkle;
  double ibubble;
  Color barBackgroundColor;
  bool isSelectedPopped;
  bool isInitialized;
  List<String> iconsChar;
  List<String> selectedIconsChar;
  List<double> iconsSize;
  List<double> selectedIconSize;
  Color initialBgColor;
  Color selectedIconColor;
  Color iconColor;
  double bottomIconsPadding;
  Color rippleColor;
  double topBarRadius;
  double barElevation;

  BottomBar({
    required this.iconsChar,
    required this.selectedIconsChar,
    required this.iconsSize,
    required this.selectedIconSize,
    required this.yTraslation,
    required this.iconScale,
    required this.barPaddingIn,
    required this.barPaddingOut,
    required this.isprinkle,
    required this.ibubble,
    required this.barBackgroundColor,
    required this.isSelectedPopped,
    required this.isInitialized,
    required this.selectedIcon,
    required this.initialBgColor,
    required this.yBubbleTraslation,
    required this.selectedIconColor,
    required this.iconColor,
    required this.bottomIconsPadding,
    required this.rippleColor,
    required this.barElevation,
    required this.topBarRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    
    double xPadding = 0 + barPaddingIn - barPaddingOut;
    double yPadding = 0 - barPaddingIn / 6 + barPaddingOut / 6;
    Color baseColor = isInitialized ? barBackgroundColor : initialBgColor;

    int numberOfIcons = iconsChar.length;

    var paint = Paint()
      ..color = baseColor
      ..strokeCap = StrokeCap.round;

    RRect rectangle = RRect.fromLTRBAndCorners(
      xPadding,
      yPadding,
      size.width - xPadding,
      size.height - yPadding,
      topLeft: Radius.circular(topBarRadius),
      topRight: Radius.circular(topBarRadius),
    );

    var path = Path();

    path.addRRect(rectangle);

    canvas.drawShadow(path, Colors.black, barElevation, false);

    canvas.drawPath(path, paint);

    void drawIcon(icon, x, y, color, scale, pIconSize) {
      ui.TextStyle iconStyle = ui.TextStyle(
        color: color,
        foreground: null,
        fontSize: pIconSize * scale,
      );

      final ui.ParagraphBuilder paragraphBuilder =
          ui.ParagraphBuilder(ui.ParagraphStyle(
        fontFamily: Icons.ac_unit.fontFamily,
        fontSize: 90,
        fontStyle: FontStyle.normal,
      ))
            ..pushStyle(iconStyle)
            ..addText(icon);

      final ui.Paragraph paragraph = paragraphBuilder.build()
        ..layout(const ui.ParagraphConstraints(
          width: 50,
        ));

      canvas.drawParagraph(paragraph, Offset(xPadding + x, y));
    }

    for (var nIcon = 0; nIcon < numberOfIcons; nIcon++) {
      double squareWidth = 0;
      double xPosition = 0;
      // print(selectedIconSize[nIcon]);
      double iconParametralSize =
          nIcon == selectedIcon ? selectedIconSize[nIcon] : iconsSize[nIcon];

      // if (false) {
      // squareWidth = (size.width - (xPadding * 2)) / (numberOfIcons + 1);
      // xPosition = squareWidth +
      //     squareWidth * nIcon -
      //     (nIcon == selectedIcon
      //             ? iconParametralSize * iconScale
      //             : iconParametralSize) /
      // 2;
      // } else {
      squareWidth = (size.width - (xPadding * 2)) / (numberOfIcons * 2);
      xPosition = (squareWidth + squareWidth * nIcon * 2) -
          (nIcon == selectedIcon && isInitialized
                  ? iconParametralSize * iconScale
                  : iconParametralSize) /
              2;
      // }
      if (nIcon == selectedIcon && isInitialized) {
        canvas.drawCircle(
            ui.Offset(
                xPadding + squareWidth + squareWidth * nIcon * 2,
                (size.height / 2 -
                        (nIcon == selectedIcon
                                ? isprinkle * iconScale
                                : isprinkle) /
                            2) -
                    (nIcon == selectedIcon
                        ? yBubbleTraslation - isprinkle / 2
                        : 0) +
                    yPadding -
                    bottomIconsPadding),
            ibubble * iconScale,
            Paint()..color = baseColor);
      }

      drawIcon(
          ((nIcon == selectedIcon) && (isSelectedPopped || !isInitialized)
              ? selectedIconsChar[nIcon]
              : iconsChar[nIcon]),
          xPosition,
          (size.height / 2 -
                  (nIcon == selectedIcon && isInitialized
                          ? iconParametralSize * iconScale
                          : iconParametralSize) /
                      2) -
              (nIcon == selectedIcon && isInitialized ? yTraslation : 0) +
              yPadding -
              bottomIconsPadding,
          ((nIcon == selectedIcon) && (isSelectedPopped || !isInitialized)
              ? selectedIconColor
              : iconColor),
          (nIcon == selectedIcon && isInitialized ? iconScale : 1),
          iconParametralSize);
      if (nIcon == selectedIcon) {
        canvas.drawCircle(
            ui.Offset(squareWidth + squareWidth * nIcon * 2,
                size.height / 2 - bottomIconsPadding),
            isprinkle,
            Paint()
              ..color = rippleColor
              ..strokeWidth = 24 - isprinkle
              ..style = ui.PaintingStyle.stroke);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
