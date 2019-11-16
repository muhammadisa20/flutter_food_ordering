import 'package:flutter/material.dart';

class CenterLoadingError extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  CenterLoadingError(this.child, {this.isExpanded});
  @override
  Widget build(BuildContext context) {
    if (isExpanded != null) {
      return Expanded(
        child: Center(child: child),
      );
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 100),
      child: child,
    );
  }
}
