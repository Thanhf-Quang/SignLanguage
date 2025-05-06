import 'dart:typed_data';

class Question{
  String questionId;
  String questionText;
  int correctAnswerIndex;
  List<String> options;
  String mediaUrl;

  Uint8List? selectedMediaFile;
  String? selectedMediaName;
  String? mediaType;

  Question({
    required this.questionId,
    required this.questionText,
    required this.correctAnswerIndex,
    required this.options,
    this.mediaUrl = '',
    this.selectedMediaFile,
    this.selectedMediaName,
    this.mediaType,
});

  factory Question.fromMap(Map<String, dynamic> map,String id){
    return Question(
        questionId: id,
        questionText: map['questionText'],
        correctAnswerIndex: map['correctAnswer'],
        options: List<String>.from(map['options']),
        mediaUrl: map['mediaUrl'],
        mediaType: map['mediaType']
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'questionId': questionId,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswerIndex,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
    };
  }
}