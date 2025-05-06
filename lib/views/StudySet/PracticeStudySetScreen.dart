import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../models/StudyItem.dart';
import '../../controllers/PracticeStudySetController.dart';
import '../../views/StudySet/RecordCameraScreen.dart';
import '../../controllers/RecordAnalysisController.dart'; // ← xử lý gọi AI
import '../../services/StudySetService.dart';

class PracticeStudySetScreen extends StatefulWidget {
  final List<String> itemIds;
  final String studySetId;

  const PracticeStudySetScreen({Key? key, required this.itemIds,required this.studySetId,}) : super(key: key);

  @override
  State<PracticeStudySetScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeStudySetScreen> {
  final PracticeController _controller = PracticeController();
  final FlutterTts _tts = FlutterTts();
  final StudySetService _studysetService = StudySetService(); // Đặt dòng này bên trong class _PracticeStudySetScreenState

  List<StudyItem> _items = [];
  List<double> _scoreList = [];
  int _currentIndex = 0;
  bool _loading = true;
  double _score = 0.0;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _controller.loadItems(widget.itemIds);
    setState(() {
      _items = items;
      _loading = false;
      _scoreList = List.filled(items.length, 0.0);
    });
  }

  void _speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  void _nextItem() async {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _score = _scoreList[_currentIndex]; // ← dùng lại điểm cũ nếu có
      });
    } else {
      await _studysetService.saveScoresAndStatement(
        widget.studySetId,
        _scoreList,
        "Completed!",
      );
      Navigator.pop(context, _scoreList);
    }
}


  void _recordUserAction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraRecordScreen(
          onVideoRecorded: (File video) async {
            try {
              final score = await uploadVideoForAnalysis(
                video,
                _items[_currentIndex].videoUrl,
              );

              setState(() {
                _score = score;
              });

              // Cập nhật _scoreList tại chỉ số hiện tại
              if (_scoreList.length > _currentIndex) {
                _scoreList[_currentIndex] = score;
              } else {
                _scoreList.add(score);
              }

              // Ghi đè toàn bộ scores vào Firestore mỗi lần record
              await _studysetService.saveScoresAndStatement(
                widget.studySetId,
                _scoreList,
                "Practicing in progress...",
              );

            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Lỗi phân tích video: $e")),
              );
            }
          },
        ),
      ),
    );
  }

  Color getAccuracyColor(double score) {
    if (score < 0.5) return Colors.red;
    if (score < 0.8) return Colors.amber;
    return Colors.green;
  }

  
  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final item = _items[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.keyword, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.lightBlue, size: 30),
                    onPressed: () => _speak(item.keyword),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                item.description,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.videoUrl,
                height: 300,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 48, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Accuracy: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${(_score * 100).toStringAsFixed(1)}%"),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: _score,
                    backgroundColor: Colors.grey.shade300,
                    color: getAccuracyColor(_score),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _recordUserAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.videocam, color: Colors.white, size: 28),
                  ),
                  ElevatedButton(
                    onPressed: _nextItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
