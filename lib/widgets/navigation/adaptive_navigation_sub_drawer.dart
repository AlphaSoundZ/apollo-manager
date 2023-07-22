import 'package:flutter/material.dart';
import '../../destinations.dart';

class SubDrawer extends StatefulWidget {
  const SubDrawer({
    super.key,
    required this.selectedView,
    required this.selectedSubView,
    required this.isOpen,
    this.onViewSelected,
  });

  final int selectedView;
  final int selectedSubView;
  final bool isOpen;
  final ValueChanged<int>? onViewSelected;

  @override
  State<SubDrawer> createState() => SubDrawerState();
}

class SubDrawerState extends State<SubDrawer> {
  int selectedView = 0;
  int selectedSubView = 0;

  List<Destination> destinations = Destinations().destinations;

  @override
  Widget build(BuildContext context) {
    selectedView = widget.selectedView;
    selectedSubView = widget.selectedSubView;

    return AnimatedClipRect(
      open: widget.isOpen,
      horizontalAnimation: true,
      verticalAnimation: false,
      alignment: Alignment.topLeft,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      reverseCurve: Curves.easeInOutQuint,
      child: Container(
        width: 250,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FloatingActionButton.extended(
              clipBehavior: Clip.antiAlias,
              heroTag: "Create New",
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              foregroundColor:
                  Theme.of(context).colorScheme.onTertiaryContainer,
              label: Text(
                  "New ${destinations[selectedView].subDestinations[selectedSubView].fabLabel}"),
              icon: Icon(destinations[selectedView]
                  .subDestinations[selectedSubView]
                  .fabIcon),
              onPressed: () {},
              elevation: 0,
            ),
            const SizedBox(height: 16),
            Column(
              children: destinations[selectedView]
                  .subDestinations
                  .map<Widget>(
                    (e) => SizedBox(
                      height: 32.0,
                      width: double.infinity,
                      child: FilledButton.tonalIcon(
                        icon: Icon(e.icon),
                        label: Text(
                          e.label,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                        style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          backgroundColor: MaterialStateProperty.all<Color>(
                            selectedSubView ==
                                    destinations[selectedView]
                                        .subDestinations
                                        .indexOf(e)
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedSubView = destinations[selectedView]
                                .subDestinations
                                .indexOf(e);
                          });
                          if (widget.onViewSelected != null) {
                            widget.onViewSelected!(selectedSubView);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedClipRect extends StatefulWidget {
  @override
  _AnimatedClipRectState createState() => _AnimatedClipRectState();

  final Widget child;
  final bool open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;

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
    this.curve = Curves.linear,
    this.reverseCurve,
    this.animationBehavior = AnimationBehavior.normal,
  }) : super(key: key);
}

class _AnimatedClipRectState extends State<AnimatedClipRect>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

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
        animationBehavior: widget.animationBehavior);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve ?? widget.curve,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open
        ? _animationController.forward()
        : _animationController.reverse();

    return ClipRect(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _animation.value : 1.0,
            widthFactor: widget.horizontalAnimation ? _animation.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
