import 'package:flutter/material.dart';

import '../../models/StudyItem.dart';
import '../../models/StudySet.dart';
import '../../controllers/StudysetController.dart';
import '../../views/StudySet/PracticeStudySetScreen.dart';
import '../../services/StudySetService.dart';

class StudySetDetailScreen extends StatefulWidget {
  final String studySetId;

  const StudySetDetailScreen({Key? key, required this.studySetId}) : super(key: key);

  @override
  State<StudySetDetailScreen> createState() => _StudySetDetailScreenState();
}

class _StudySetDetailScreenState extends State<StudySetDetailScreen> {
  final StudySetController _controller = StudySetController();
  final StudySetService _studySetService = StudySetService();

  StudySet? _studySet;
  List<StudyItem> _studyItems = [];
  List<double> _scores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStudySetAndItems();
  }

  Future<void> _loadStudySetAndItems() async {
    setState(() => _loading = true);
    final set = await _controller.getStudySetById(widget.studySetId);
    if (set != null) {
      final items = await _controller.getItemsFromSet(set);
      final scores = await _studySetService.getScoresOfStudySet(widget.studySetId);
      setState(() {
        _studySet = set;
        _studyItems = items;
        _scores = scores;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_studySet == null) {
      return const Scaffold(body: Center(child: Text("Study set not found.")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.orange),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.menu_book, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 8),
            Text(
              _studySet!.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Follow ${_studySet!.createBy}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.thumb_up_alt_outlined), onPressed: () {}),
                IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add item'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            if (_studySet!.statement != null && _studySet!.statement!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _studySet!.statement!,
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                ),
              ),
            const SizedBox(height: 8),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Accuracy", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _studyItems.length,
                        itemBuilder: (context, index) {
                          final item = _studyItems[index];
                          final score = (index < _scores.length)
                              ? "${(_scores[index] * 100).toStringAsFixed(0)}%"
                              : "N/A";

                          return ListTile(
                            leading: const Icon(Icons.play_circle),
                            title: Text(item.keyword),
                            subtitle: Text(item.description),
                            trailing: Text(score),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PracticeStudySetScreen(
                        itemIds: _studySet!.studyItems,
                        studySetId: widget.studySetId,
                      ),
                    ),
                  );

                  if (result != null && result is List<double>) {
                    setState(() {
                      _scores = result;
                    });
                  }
                },
                child: const Text('Practice', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
