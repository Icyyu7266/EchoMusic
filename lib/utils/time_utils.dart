class TimeUtils {
  /// 秒数转 分:秒 格式（如 240 → 4:00，3 → 0:03）
  static String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  /// 重载：Duration 转 分:秒 格式
  static String formatDuration(Duration duration) {
    return formatTime(duration.inSeconds);
  }
}
