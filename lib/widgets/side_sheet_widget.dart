import 'package:flutter/material.dart';
import '../destinations.dart';

class SideSheet extends StatefulWidget {
  const SideSheet({
    super.key,
    required this.isOpen,
    required this.child,
  });

  final bool isOpen;
  final Widget child;

  @override
  State<SideSheet> createState() => SideSheetState();
}

class SideSheetState extends State<SideSheet> {
  List<Destination> destinations = Destinations().destinations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceContainer = Color.alphaBlend(
      colorScheme.primary.withOpacity(0.08),
      colorScheme.surface,
    );

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          width: widget.isOpen ? 8 : 0,
          curve: Curves.easeInOutCubicEmphasized,
        ),
        AnimatedClipRect(
          open: widget.isOpen,
          animateSize: true,
          horizontalAnimation: true,
          verticalAnimation: false,
          alignment: Alignment.topLeft,
          duration: const Duration(milliseconds: 700),
          sizeCurve: Curves.easeInOutCubicEmphasized,
          reverseSizeCurve: Curves.easeInOutCubicEmphasized.flipped,
          child: Container(
            decoration: (BoxDecoration(
              color: surfaceContainer,
            )),
            width: 330,
            height: double.infinity,
            child: AnimatedClipRect(
              open: widget.isOpen,
              animateOpacity: true,
              animateSize: false,
              duration: const Duration(milliseconds: 700),
              opacityCurve: Curves.easeInOutQuad,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: widget.child,
              ),
            ),
          ),
        ),
        // animated sized box for spacing
        AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          width: widget.isOpen ? 8 : 0,
          curve: Curves.easeInOutCubicEmphasized,
        ),
      ],
    );
  }
}

class AnimatedClipRect extends StatefulWidget {
  @override
  AnimatedClipRectState createState() => AnimatedClipRectState();

  final Widget child;
  final bool open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve? sizeCurve;
  final Curve? reverseSizeCurve;
  final Curve? opacityCurve;
  final Curve? opacityReverseCurve;
  final bool animateSize;
  final bool animateOpacity;

  ///The behavior of the controller when [AccessibilityFeatures.disableAnimations] is true.
  final AnimationBehavior animationBehavior;

  const AnimatedClipRect({
    Key? key,
    required this.child,
    required this.open,
    this.horizontalAnimation = true,
    this.verticalAnimation = true,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration,
    this.sizeCurve = Curves.linear,
    this.reverseSizeCurve,
    this.opacityCurve = Curves.linear,
    this.opacityReverseCurve,
    this.animateSize = false,
    this.animateOpacity = false,
    this.animationBehavior = AnimationBehavior.normal,
  }) : super(key: key);
}

class AnimatedClipRectState extends State<AnimatedClipRect>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _sizeAnimation;
  late Animation _fadeAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.reverseDuration ?? widget.duration,
      vsync: this,
      value: widget.open ? 1.0 : 0.0,
      animationBehavior: widget.animationBehavior,
    );
    _sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          1.0,
          curve: widget.sizeCurve ?? Curves.linear,
        ),
        reverseCurve: widget.reverseSizeCurve ?? widget.sizeCurve,
      ),
    );
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.4,
          1.0,
          curve: widget.opacityCurve ?? Curves.linear,
        ),
        reverseCurve: Interval(
          0.4,
          1.0,
          curve: widget.opacityReverseCurve ??
              widget.opacityCurve ??
              Curves.linear,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open
        ? _animationController.forward()
        : _animationController.reverse();

    return ClipRRect(
      borderRadius: BorderRadius.circular(56.0 / 2),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return buildAnimationContent(child!);
        },
        child: widget.child,
      ),
    );
  }

  Widget buildAnimationContent(Widget child) {
    Widget alignContent = widget.animateSize
        ? Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _sizeAnimation.value : 1.0,
            widthFactor:
                widget.horizontalAnimation ? _sizeAnimation.value : 1.0,
            child: child,
          )
        : child;

    return widget.animateOpacity
        ? Opacity(
            opacity: _fadeAnimation.value,
            child: alignContent,
          )
        : alignContent;
  }
}
