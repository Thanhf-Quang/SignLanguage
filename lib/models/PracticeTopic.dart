// lib/models/practice_topic.dart
class PracticeTopic {
  final String topicid;
  final String topicTitle;
  final String symbolTopic;
  final List<String> keywordIds;

  PracticeTopic({
    required this.topicid,
    required this.topicTitle,
    required this.symbolTopic,
    required this.keywordIds,
  });

  factory PracticeTopic.fromMap(Map<String, dynamic> data, String documentId) {
    return PracticeTopic(
      topicid: documentId,
      topicTitle: data['topicTitle'] ?? '',
      symbolTopic: data['symbolTopic'] ?? '',
      keywordIds: List<String>.from(data['keywords'] ?? []),
    );
  }
}
