import 'package:flutter/material.dart';

/// Passive wrapper that preserves the widget tree without showing disruptive internet snackbars.
class InternetToastListener extends StatefulWidget {
  const InternetToastListener({super.key, required this.child});
  final Widget child;

  @override
  State<InternetToastListener> createState() => InternetToastListenerState();
}

class InternetToastListenerState extends State<InternetToastListener> {
  @override
  Widget build(BuildContext context) => widget.child;
}
