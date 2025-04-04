import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CInkWell extends StatelessWidget {
  const CInkWell({required this.child, required this.onTap, super.key});
  final Widget child;
  final FutureOr<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TapDebouncer(
      onTap: () async {
        await onTap();
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      },
      builder: (BuildContext context, TapDebouncerFunc? onTap) {
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: child,
        );
      },
    );
  }
}
