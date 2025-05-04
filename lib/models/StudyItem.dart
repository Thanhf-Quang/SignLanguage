class StudyItem {
  final String id;
  final String keyword;
  final String videoUrl;
  final String description;

  StudyItem({required this.id, required this.keyword, required this.videoUrl, required this.description});

  factory StudyItem.fromMap(Map<String, dynamic> map) {
    return StudyItem(
      id: map['itemID'] ?? '',
      keyword: map['keyword'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      description: map['description'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': keyword,
      'videoUrl': videoUrl,
      'description' : description
    };
  }
}
