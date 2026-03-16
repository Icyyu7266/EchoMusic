import 'package:flutter/material.dart';
import 'package:your_project_name/models/lyric_model.dart'; // ******** 替换为你的项目名 ********

/// 歌词滚动组件：平滑滚动 + 逐行高亮
class AnimatedLyricScroll extends StatefulWidget {
  final List<LyricModel> lyrics;          // 歌词列表
  final int currentLineIndex;             // 当前播放行索引
  final double lineHeight;                // 可选：行高（默认40）

  const AnimatedLyricScroll({
    super.key,
    required this.lyrics,
    required this.currentLineIndex,
    this.lineHeight = 40.0,
  });

  @override
  State<AnimatedLyricScroll> createState() => _AnimatedLyricScrollState();
}

class _AnimatedLyricScrollState extends State<AnimatedLyricScroll> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AnimatedLyricScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 歌词行变化时，平滑滚动到当前行
    if (widget.currentLineIndex != oldWidget.currentLineIndex && widget.lyrics.isNotEmpty) {
      _scrollController.animateTo(
        widget.currentLineIndex * widget.lineHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.lyrics.length,
      physics: const ClampingScrollPhysics(), // 去掉滚动回弹，更贴合桌面端
      itemBuilder: (context, index) {
        bool isCurrent = index == widget.currentLineIndex;
        // 当前行歌词渐变高亮
        Widget lyricText = isCurrent
            ? ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(rect),
                child: Text(
                  widget.lyrics[index].text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Text(
                widget.lyrics[index].text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              );

        // 行高 + 透明度动效
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isCurrent ? widget.lineHeight : widget.lineHeight - 4,
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: isCurrent ? 1.0 : 0.6,
            duration: const Duration(milliseconds: 200),
            child: lyricText,
          ),
        );
      },
    );
  }
}
