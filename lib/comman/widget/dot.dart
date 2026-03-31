import 'package:flutter/material.dart';
import '../../core/theme/a_color.dart';

class PulseDot extends StatefulWidget {
  final double size;
  final Color color;
  const PulseDot({super.key, this.size = 7, this.color = AppColors.teal});

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _ac,
    builder: (_, __) => Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color.withOpacity(0.3 + 0.7 * _ac.value),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.4 * _ac.value),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
    ),
  );
}
