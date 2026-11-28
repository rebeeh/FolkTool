import 'package:flutter/material.dart';

/// Responsive window breakpoints aligned with compact, medium, and expanded layouts.
enum WindowSizeClass {
  compact,
  medium,
  expanded;

  static WindowSizeClass fromWidth(double width) {
    if (width >= 1024) return WindowSizeClass.expanded;
    if (width >= 720) return WindowSizeClass.medium;
    return WindowSizeClass.compact;
  }
}

/// Renders a two-column equal-height row when available width meets [breakpoint],
/// and stacks children vertically with uniform [spacing] on narrower viewports.
class ResponsivePairGrid extends StatelessWidget {
  final Widget first;
  final Widget second;
  final double breakpoint;
  final double spacing;

  const ResponsivePairGrid({
    super.key,
    required this.first,
    required this.second,
    this.breakpoint = 640,
    this.spacing = 14,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: first),
                SizedBox(width: spacing),
                Expanded(child: second),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            first,
            SizedBox(height: spacing),
            second,
          ],
        );
      },
    );
  }
}
