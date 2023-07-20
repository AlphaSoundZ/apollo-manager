import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBar extends StatefulWidget {
  const AppBar({
    super.key,
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  State<AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<AppBar> {
  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
  }

  @override
  Widget build(BuildContext context) {
    final surfaceContainer = Color.alphaBlend(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
      Theme.of(context).colorScheme.surface,
    );

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          if (wideScreen)
            SizedBox(
              // Logo + Apollo title
              width: 250,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(
                    Icons.rocket_rounded,
                    size: 34,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Apollo",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // Search bar
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: surfaceContainer,
                    ),
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              // Search icon
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                iconSize: 25,
                                onPressed: () {},
                              ),
                              prefixText: " ",
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Search",
                              // filter button
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.tune),
                                onPressed: () {},
                                iconSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 25,
                    ),
                    onPressed: () {
                      Get.offAllNamed(
                        "/settings",
                      );
                    },
                    iconSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
