import 'package:flutter/material.dart';
import 'package:simple/painter/bottom_bar.dart';

class BubbleBottomNavBar extends StatefulWidget {
  final List<BubbleNavBarItem> items;
  final int currentIndex;
  final Function onTap;
  final Duration animationDuration;
  final double height;
  final Color backgroundColor;
  final Color selectedIconColor;
  final Color iconColor;
  final double bottomIconsPadding;
  final Color rippleColor;
  final double elevation;
  final double topBarRadius;

  const BubbleBottomNavBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.selectedIconColor = Colors.black,
    this.iconColor = Colors.black,
    this.height = 100,
    this.backgroundColor = Colors.white,
    this.bottomIconsPadding = 0,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.rippleColor = Colors.black,
    this.elevation = 0,
    this.topBarRadius = 30,
  }) : super(key: key);

  @override
  State<BubbleBottomNavBar> createState() => _BubbleBottomNavBarState();
}

class BubbleNavBarItem {
  Icon icon;
  Icon? selectedIcon;
  String? label;
  Color transitionColor;

  BubbleNavBarItem({
    required this.icon,
    this.selectedIcon,
    this.label,
    this.transitionColor = const Color.fromRGBO(255, 217, 251, 1),
  });

  double? get iconSize => icon.size;
  String get iconCharCode => String.fromCharCode(icon.icon!.codePoint);
  String? get iconFontFamily => icon.icon!.fontFamily;
  double? get selectedIconSize => (selectedIcon ?? icon).size;
  String? get selectedIconCharCode =>
      String.fromCharCode((selectedIcon ?? icon).icon!.codePoint);
  String? get selectedIconFontFamily => (selectedIcon ?? icon).icon!.fontFamily;
}

class _BubbleBottomNavBarState extends State<BubbleBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> yTraslation;
  late Animation<double> yBubbleTraslation;

  late Animation<double> opacity;
  late Animation<double> barPaddingIn;
  late Animation<double> barPaddingOut;
  late Animation<double> sprinkle;
  late Animation<double> sprinkleOpacity;
  late Animation<Color?> backColor;
  late Animation<Color?> inBackColor;
  late Animation<double> reGrow;
  late Color blendColor;

  late List<String> icons;
  late List<String> selectedIcons;
  late List<double> iconsSize;
  late List<double> selectedIconsSize;

  int tappedIcon = 0;

  @override
  void initState() {
    super.initState();
    icons = widget.items.map((bubbleItem) => bubbleItem.iconCharCode).toList();
    selectedIcons = widget.items
        .map((bubbleItem) =>
            bubbleItem.selectedIconCharCode ?? bubbleItem.iconCharCode)
        .toList();
    iconsSize =
        widget.items.map((bubbleItem) => bubbleItem.iconSize ?? 24).toList();
    selectedIconsSize = widget.items
        .map((bubbleItem) => bubbleItem.selectedIconSize ?? 24)
        .toList();
  }

  final Tween<double> yTraslationTween = Tween(
    begin: 0,
    end: 10,
  );

  final Tween<double> yBubbleTraslationTween = Tween(
    begin: 0,
    end: 10,
  );
  final Tween<double> opacityTween = Tween(
    begin: 1,
    end: 0,
  );
  final Tween<double> reGrowTween = Tween(
    begin: 0,
    end: 1,
  );
  final Tween<double> barPaddingInTween = Tween(
    begin: 0,
    end: 50,
  );
  final Tween<double> barPaddingOutTween = Tween(
    begin: 0,
    end: 50,
  );
  final Tween<double> sprinkleTween = Tween(
    begin: 0,
    end: 12,
  );
  final Tween<double> sprinkleOpacityTween = Tween(
    begin: 0,
    end: 12,
  );

  ColorTween backColorTween(Color blend, Color bgColor) {
    final ColorTween backColorTween = ColorTween(
      begin: bgColor,
      end: blend,
    );

    return backColorTween;
  }

  ColorTween inBackColorTween(Color blend, Color bgColor) {
    final ColorTween inBackColorTween = ColorTween(
      begin: blend,
      end: bgColor,
    );

    return inBackColorTween;
  }

  void playAnimation(Color color, Color bgColor) {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )
      ..addListener(_update)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.dispose();
        }
      });

    yTraslation = yTraslationTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.125,
        0.675,
        curve: Curves.elasticOut,
      ),
    ));

    yBubbleTraslation = yBubbleTraslationTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.125,
        0.675,
        curve: Curves.elasticOut,
      ),
    ));

    opacity = opacityTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.625,
        0.800,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    reGrow = reGrowTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.800,
        1,
        curve: Curves.ease,
      ),
    ));

    barPaddingIn = barPaddingInTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.125,
        0.450,
        curve: Curves.decelerate,
      ),
    ));

    barPaddingOut = barPaddingOutTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.500,
        0.800,
        curve: Curves.bounceOut,
      ),
    ));

    sprinkle = sprinkleTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0,
        0.125,
        curve: Curves.bounceOut,
      ),
    ));

    backColor = backColorTween(color, bgColor).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0,
        0.250,
        curve: Curves.easeIn,
      ),
    ));

    inBackColor = inBackColorTween(color, bgColor).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.625,
        0.875,
        curve: Curves.easeIn,
      ),
    ));

    _controller.forward();
  }

  void playSelectedAnimation(Color color, Color bgColor) {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.animationDuration.inMilliseconds/2).truncate()),
    )
      ..addListener(_updateSelected)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.dispose();
        }
      });

    barPaddingIn = barPaddingInTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0,
        0.700,
        curve: Curves.decelerate,
      ),
    ));

    barPaddingOut = barPaddingOutTween.animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.700,
        1,
        curve: Curves.bounceOut,
      ),
    ));

    _controller.forward();
  }

  double i = 0;
  double yBubbleT = 0;

  double iopa = 0;
  double ibarPaddingIn = 0;
  double ibarPaddingOut = 0;
  double isprinkle = 0;
  double ibubble = 0;
  Color? ibackColor = Colors.white;
  bool isSelectedPopped = false;
  bool isInitialized = false;

  void _update() {
    isInitialized = true;
    setState(() {
      if (_controller.value <= 0.800) {
        i = yTraslation.value * 10;
        yBubbleT = yBubbleTraslation.value * 10;
      } else {
        yBubbleT = 0;
        i = 0;
      }

      ibarPaddingIn = barPaddingIn.value;

      if (_controller.value <= 0.300) {
        ibackColor = backColor.value;
      } else {
        ibackColor = inBackColor.value;
      }

      if (_controller.value > 0.125) {
        isprinkle = 0;
      } else {
        isprinkle = sprinkle.value * 2;
      }

      if (_controller.value < 0.800) {
        iopa = opacity.value;
        isSelectedPopped = false;
      } else {
        iopa = reGrow.value;
        isSelectedPopped = true;
      }
      ibarPaddingOut = barPaddingOut.value;
      ibubble = sprinkle.value * 2;
    });
  }

  void _updateSelected() {
    isInitialized = true;
    setState(() {
      yBubbleT = 0;
      i = 0;

      ibarPaddingIn = barPaddingIn.value/3;

     
        isprinkle = 0;
 

      iopa = reGrow.value;
      isSelectedPopped = true;

      ibarPaddingOut = barPaddingOut.value/3;
      ibubble = 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BottomBar(
        iconsChar: icons,
        selectedIconsChar: selectedIcons,
        iconsSize: iconsSize,
        selectedIconSize: selectedIconsSize,
        yTraslation: i,
        iconScale: iopa,
        barPaddingIn: ibarPaddingIn,
        barPaddingOut: ibarPaddingOut,
        isprinkle: isprinkle,
        ibubble: ibubble,
        barBackgroundColor: ibackColor as Color,
        isSelectedPopped: isSelectedPopped,
        isInitialized: isInitialized,
        selectedIcon: widget.currentIndex,
        initialBgColor: widget.backgroundColor,
        yBubbleTraslation: yBubbleT,
        iconColor: widget.iconColor,
        selectedIconColor: widget.selectedIconColor,
        bottomIconsPadding: widget.bottomIconsPadding,
        rippleColor: widget.rippleColor,
        barElevation: widget.elevation,
        topBarRadius: widget.topBarRadius,
      ),
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            left: 0 + ibarPaddingIn - ibarPaddingOut,
            right: 0 + ibarPaddingIn - ibarPaddingOut,
            bottom: widget.bottomIconsPadding * 2,
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.items
                  .asMap()
                  .entries
                  .map((item) => GestureDetector(
                        child: Container(
                          height: iconsSize[item.key] + 20,
                          width: iconsSize[item.key] + 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onTap: () {
                          if (!isInitialized) {
                            widget.onTap(item.key);
                            playAnimation(item.value.transitionColor,
                                widget.backgroundColor);
                          } else {
                            if (_controller.status ==
                                AnimationStatus.completed) {
                              if (item.key == widget.currentIndex) {
                                playSelectedAnimation(
                                    item.value.transitionColor,
                                    widget.backgroundColor);
                                return;
                              }
                              widget.onTap(item.key);
                              playAnimation(item.value.transitionColor,
                                  widget.backgroundColor);
                            }
                          }
                        },
                      ))
                  .toList()),
        ),
        width: double.infinity,
        height: widget.height + widget.bottomIconsPadding,
      ),
    );
  }
}
