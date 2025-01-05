import "package:flutter/material.dart";

class TabContainer extends StatelessWidget {
  final bool selected;
  final Widget child;

  const TabContainer({
    super.key,
    required this.selected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !selected,
      child: TickerMode(
        enabled: selected,
        child: child,
      ),
    );
  }
}
