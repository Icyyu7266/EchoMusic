/// 歌词数据模型
class LyricModel {
  final String text; // 歌词文本
  final int time;    // 歌词对应时间戳（秒）
  final String? translation; // 可选：歌词翻译
  final String? phonetic;    // 可选：歌词音译

  LyricModel({
    required this.text,
    required this.time,
    this.translation,
    this.phonetic,
  });
}
