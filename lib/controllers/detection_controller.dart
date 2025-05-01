import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/recognition_model.dart';

class DetectionController {
  final RecognitionModel _model = RecognitionModel();

  Future<String> captureAndSendImage(CameraController cameraController) async {
    if (!cameraController.value.isInitialized) return "Camera not ready";

    final directory = await getTemporaryDirectory();
    final path = join(directory.path, '${DateTime.now()}.png');

    try {
      final XFile file = await cameraController.takePicture();
      final imageFile = File(file.path);
      return await _model.sendImageForPrediction(imageFile);
    } catch (e) {
      return "Error: $e";
    }
  }
}
