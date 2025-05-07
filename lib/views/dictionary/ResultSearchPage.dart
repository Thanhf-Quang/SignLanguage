import 'package:flutter/material.dart';
import '../../widgets/custom/CustomAppBar.dart';
import 'package:video_player/video_player.dart';
import '../quiz/VideoPlayerWidget.dart';


class ResultSearchPage extends StatefulWidget {
  final String keyWord;
  final String videoUrl;
  final String description;

  const ResultSearchPage({
    super.key,
    required this.keyWord,
    required this.videoUrl,
    required this.description,
  });

  @override
  State<ResultSearchPage> createState() => _ResultSearchPageState();
}

class _ResultSearchPageState extends State<ResultSearchPage> {
  late VideoPlayerController _controller;

  bool get isVideo =>
      widget.videoUrl.toLowerCase().endsWith('.mp4') ||
          widget.videoUrl.toLowerCase().contains('video');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Search Result"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: 380,
                child: isVideo
                    ? VideoPlayerWidget(videoUrl: widget.videoUrl)
                    : Image.network(
                  widget.videoUrl,
                  fit: BoxFit.cover,  // Đảm bảo ảnh đầy đủ
                  height: 250,  // Tăng kích thước ảnh
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text("Không thể tải ảnh GIF.");
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.keyWord,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10,),
              Text(
                "Description: ${widget.description}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}