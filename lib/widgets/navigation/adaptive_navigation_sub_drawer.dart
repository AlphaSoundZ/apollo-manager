import '../../enums/which_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../destinations.dart';
import '../../models/data_model.dart';

class SubDrawer extends StatefulWidget {
  const SubDrawer({
    super.key,
    required this.selectedView,
    required this.selectedSubView,
    required this.isOpen,
    required this.destinations,
    this.onViewSelected,
    this.onFABPressed,
  });

  final int selectedView;
  final int selectedSubView;
  final bool isOpen;
  final List<Destination> destinations;
  final ValueChanged<int>? onViewSelected;
  final void Function()? onFABPressed;

  @override
  State<SubDrawer> createState() => SubDrawerState();
}

class SubDrawerState extends State<SubDrawer> {
  int selectedView = 0;
  int selectedSubView = 0;

  @override
  Widget build(BuildContext context) {
    selectedView = widget.selectedView;
    selectedSubView = widget.selectedSubView;

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
          alignment: Alignment.topRight,
          duration: const Duration(milliseconds: 700),
          sizeCurve: Curves.easeInOutCubicEmphasized,
          reverseSizeCurve: Curves.easeInOutCubicEmphasized.flipped,
          child: Container(
            decoration: (BoxDecoration(
              color: surfaceContainer,
            )),
            width: 250,
            child: AnimatedClipRect(
              open: widget.isOpen,
              animateOpacity: true,
              animateSize: false,
              duration: const Duration(milliseconds: 700),
              opacityCurve: Curves.easeInOutQuad,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FloatingActionButton.extended(
                      clipBehavior: Clip.antiAlias,
                      heroTag: "Create New",
                      // backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      // foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                      label: Text(
                          "New ${widget.destinations[selectedView].subDestinations[selectedSubView].fabLabel}"),
                      icon: Icon(
                        (widget
                                    .destinations[selectedView]
                                    .subDestinations[selectedSubView]
                                    .whichData !=
                                null)
                            ? (widget
                                        .destinations[selectedView]
                                        .subDestinations[selectedSubView]
                                        .fabIcon !=
                                    null)
                                ? widget.destinations[selectedView]
                                    .subDestinations[selectedSubView].fabIcon
                                : widget
                                    .destinations[selectedView]
                                    .subDestinations[selectedSubView]
                                    .whichData!
                                    .icons
                                    .multiple
                            : Icons.add,
                      ),
                      onPressed: widget.onFABPressed,
                      elevation: 0,
                    ),
                    const SizedBox(height: 32),
                    Column(
                      verticalDirection: VerticalDirection.up,
                      children: List.from(widget
                          .destinations[selectedView].subDestinations
                          .map<Widget>(
                            (e) => SizedBox(
                              height: 32.0, // alternative: 40.0
                              width: double.infinity,
                              child: FilledButton.tonalIcon(
                                icon: Icon(e.icon),
                                label: Row(
                                  children: [
                                    Text(
                                      e.label,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: selectedSubView ==
                                                widget
                                                    .destinations[selectedView]
                                                    .subDestinations
                                                    .indexOf(e)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (e.whichData != null &&
                                        widget
                                            .destinations[selectedView]
                                            .subDestinations[selectedSubView]
                                            .showAmount)
                                      Text(
                                        // get Text from provider by counting amount of data
                                        Provider.of<DataModel>(context)
                                            .get(context, e.whichData!)
                                            .data
                                            .length
                                            .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: selectedSubView ==
                                                  widget
                                                      .destinations[
                                                          selectedView]
                                                      .subDestinations
                                                      .indexOf(e)
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      )
                                  ],
                                ),
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    selectedSubView ==
                                            widget.destinations[selectedView]
                                                .subDestinations
                                                .indexOf(e)
                                        ? colorScheme.secondaryContainer
                                        : surfaceContainer,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedSubView = widget
                                        .destinations[selectedView]
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
                          .toList()
                          .reversed), // reversed + verticalDirection.up = changes the z-order of the buttons
                    ),
                  ],
                ),
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
