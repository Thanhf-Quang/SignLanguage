import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RecognitionModel {
  Future<String> sendImageForPrediction(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.60.18.195:5000/predict'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        return decoded.toString();
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
