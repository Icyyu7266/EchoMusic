import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 通用交互卡片：带点击缩放+阴影动效
class AnimatedMusicCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AnimatedMusicCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: onTap == null 
            ? 1.0 
            : (GestureDetector.maybeOf(context)?.isTapDown == true ? 0.96 : 1.0),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(
                  onTap == null 
                      ? 0.05 
                      : (GestureDetector.maybeOf(context)?.isTapDown == true ? 0.08 : 0.05)
                ),
                blurRadius: onTap == null 
                    ? 4 
                    : (GestureDetector.maybeOf(context)?.isTapDown == true ? 6 : 4),
                offset: Offset(
                  0, 
                  onTap == null 
                      ? 2 
                      : (GestureDetector.maybeOf(context)?.isTapDown == true ? 3 : 2)
                ),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
