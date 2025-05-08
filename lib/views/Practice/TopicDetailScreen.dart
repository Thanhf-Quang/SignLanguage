import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/PracticeTopic.dart';
import '../../models/StudyItem.dart';
import '../../controllers/PracticeController.dart';

class TopicDetailScreen extends StatefulWidget {
  final PracticeTopic topic;
  final String topicId;

  TopicDetailScreen({
    Key? key,
    required this.topicId,
    required this.topic,
  }) : super(key: key);

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final PracticeController _controller = PracticeController();
  List<StudyItem> _studyItems = [];
  bool _loading = true;
  List<PracticeTopic> _otherTopics = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final topic = await _controller.loadTopicDetail(widget.topicId);
    if (topic != null) {
      final items = await _controller.loadStudyItemsFromTopic(topic);
      final allTopics = await _controller.fetchPracticeTopics();
      final others = allTopics.where((t) => t.topicid != widget.topicId).toList();
      setState(() {
        _studyItems = items;
        _loading = false;
        _otherTopics = others;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      appBar: AppBar(
        title: Text(widget.topic.topicTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _studyItems.map((item) {
                return ElevatedButton(
                  onPressed: () async {
                    // TODO: Chuyển sang chi tiết studyItem
                    final detailedItem = await _controller.loadStudyItemDetail(item.id);

                    if (detailedItem != null) {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFFFFF8EE),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        isScrollControlled: true,
                        builder: (context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  detailedItem.keyword,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: detailedItem.videoUrl,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 48, color: Colors.red),
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  detailedItem.description,
                                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Không thể tải thông tin chi tiết.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(item.keyword),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text('Other Categories', style: TextStyle(color: Colors.grey)),
            SizedBox(
                height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _otherTopics.length,
                itemBuilder: (context, index) {
                  final topic = _otherTopics[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TopicDetailScreen(
                            topicId: topic.topicid,
                            topic: topic,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.network(
                              topic.symbolTopic,
                              fit: BoxFit.contain,
                              width: 60,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            topic.topicTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
