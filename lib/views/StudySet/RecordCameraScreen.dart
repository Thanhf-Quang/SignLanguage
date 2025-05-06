import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraRecordScreen extends StatefulWidget {
  final Function(File video) onVideoRecorded;

  const CameraRecordScreen({Key? key, required this.onVideoRecorded}) : super(key: key);

  @override
  _CameraRecordScreenState createState() => _CameraRecordScreenState();
}

class _CameraRecordScreenState extends State<CameraRecordScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    final frontCamera = _cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller.initialize();
    if (!mounted) return;
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_controller.value.isInitialized || _controller.value.isRecordingVideo) return;

    await _controller.startVideoRecording();
    setState(() => _isRecording = true);

    // Ghi hình 6 giây
    await Future.delayed(Duration(seconds: 6));

    final recordedFile = await _controller.stopVideoRecording();
    setState(() => _isRecording = false);

    // Gửi video về màn trước
    widget.onVideoRecorded(File(recordedFile.path));

    Navigator.pop(context); // trở về màn trước
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialized
          ? Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _isRecording ? null : _startRecording,
                icon: Icon(Icons.videocam),
                label: Text("Start Recording"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: StadiumBorder(),
                ),
              ),
            ),
          )
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }

}
