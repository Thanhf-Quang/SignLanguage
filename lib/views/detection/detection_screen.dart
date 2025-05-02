import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../controllers/detection_controller.dart';

Timer? _timer;
String recognizedText = "";
String? pendingChar;

List<CameraDescription>? cameras;

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});
  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  CameraController? _cameraController;
  String? _result = "";
  final DetectionController _controller = DetectionController();

  @override
  void initState() {
    super.initState();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
      _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _timer = Timer.periodic(Duration(seconds: 1), (_) => captureAndSendImage());
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> captureAndSendImage() async {
    if (_cameraController == null) return;
    String result = await _controller.captureAndSendImage(_cameraController!);
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFCF3),
        title: Text('Hand Gesture Recognition', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFFFFCF3),
        child: Stack(
          children: [
            CameraPreview(_cameraController!),
            Center(
              child: SizedBox(
                height: 48, // hoặc 50-60 tùy độ cao nút trước đó
              ),
            ),
            if (_result != null && _result!.isNotEmpty)
              Positioned(
                bottom: 180,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Color(0xFF4d200d).withOpacity(0.7),
                  child: Text(
                    _result!,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recognizedText,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_result != null && _result!.isNotEmpty && !_result!.contains("Error")) {
                              if (_result! == "Space") {
                                recognizedText += ' ';
                              } else {
                                recognizedText += _result!;
                                pendingChar = _result!;
                              }
                            }
                          });
                        },
                        child: buildActionButton(Icons.check),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (recognizedText.isNotEmpty) {
                              recognizedText = recognizedText.substring(0, recognizedText.length - 1);
                            }
                          });
                        },
                        child: buildActionButton(Icons.backspace),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFFF7043)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
