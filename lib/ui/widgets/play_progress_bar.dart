import 'package:flutter/material.dart';
import 'package:your_project/utils/time_utils.dart'; // 替换为你的项目名

class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0-1 进度值
  final int totalSeconds; // 音乐总时长（秒）
  final ValueChanged<double>? onChanged;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.totalSeconds,
    this.onChanged,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  double _hoverX = 0.0;
  bool _isHover = false;

  void _updateProgress(double value) {
    value = value.clamp(0.0, 1.0);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double barWidth = constraints.maxWidth - 20;
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // 背景条
            Container(
              width: barWidth,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.grey[300]!.withOpacity(0.3),
              ),
            ),
            // 进度条（动画过渡）
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: barWidth * widget.progress,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Theme.of(context).primaryColor,
              ),
            ),
            // 拖动滑块
            Positioned(
              left: barWidth * widget.progress - 6,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: _isHover ? 1.2 : 1.0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 4)],
                  ),
                ),
              ),
            ),
            // Hover提示
            if (_isHover)
              Positioned(
                left: _hoverX - 40,
                top: -30,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    TimeUtils.formatTime((_hoverX / barWidth * widget.totalSeconds).toInt()),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            // 点击/拖动区域
            MouseRegion(
              onHover: (event) {
                setState(() {
                  _isHover = true;
                  _hoverX = event.localPosition.dx.clamp(0.0, barWidth);
                });
              },
              onExit: (event) => setState(() => _isHover = false),
              child: GestureDetector(
                onTapDown: (details) => _updateProgress(details.localPosition.dx / barWidth),
                onHorizontalDragUpdate: (details) => _updateProgress(details.localPosition.dx / barWidth),
                child: SizedBox(width: barWidth, height: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
