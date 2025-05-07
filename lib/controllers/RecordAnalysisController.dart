import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<double> uploadVideoForAnalysis(File videoFile, String gifUrl) async {
  final uri = Uri.parse('http://192.168.100.151:5000/analyze');
  var request = http.MultipartRequest('POST', uri);

  request.fields['gif_url'] = gifUrl;
  request.files.add(await http.MultipartFile.fromPath('video', videoFile.path));

  final response = await request.send();
  if (response.statusCode == 200) {
    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);
    return data['score'];
  } else {
    throw Exception('Failed to upload video');
  }
}
