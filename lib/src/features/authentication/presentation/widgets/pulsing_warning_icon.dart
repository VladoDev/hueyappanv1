import 'package:flutter/material.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';

class PulsingWarningIcon extends StatefulWidget {
  const PulsingWarningIcon({super.key});

  @override
  State<PulsingWarningIcon> createState() => _PulsingWarningIconState();
}

class _PulsingWarningIconState extends State<PulsingWarningIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vc = context.vecinalColors;
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.15).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: vc.emergencyIcon.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: vc.emergencyIcon, width: 2),
        ),
        child: Icon(
          Icons.warning_amber_rounded,
          color: vc.emergencyIcon,
          size: 64,
        ),
      ),
    );
  }
}
