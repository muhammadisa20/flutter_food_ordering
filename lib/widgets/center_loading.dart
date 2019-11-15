import 'package:flutter/material.dart';

class CenterLoadingError extends StatelessWidget {
  final Widget child;
  CenterLoadingError(this.child);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(child: child),
    );
  }
}
