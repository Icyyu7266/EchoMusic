import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedAlbumCover extends StatefulWidget {
  final String coverUrl; // 专辑封面地址（本地/网络）
  final bool isPlaying;

  const AnimatedAlbumCover({super.key, required this.coverUrl, required this.isPlaying});

  @override
  State<AnimatedAlbumCover> createState() => _AnimatedAlbumCoverState();
}

class _AnimatedAlbumCoverState extends State<AnimatedAlbumCover> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool _isHover = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    );

    if (widget.isPlaying) _rotationController.repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedAlbumCover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() => _isHover = true),
      onExit: (event) => setState(() => _isHover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHover ? 1.05 : 1.0,
        child: RotationTransition(
          turns: _rotationAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: // 适配你的图片加载方式（本地/网络）
                // 网络图片：Image.network(widget.coverUrl, ...)
                // 本地图片：Image.asset(widget.coverUrl, ...)
                Image.asset(
              widget.coverUrl,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
