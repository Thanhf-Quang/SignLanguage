import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/ImgUploadService.dart';
import './QuizScreen.dart';
import '../../widgets/custom/CustomAppBar.dart';
import '../../widgets/custom/DialogHelper.dart';
import '../../widgets/custom/customButton.dart';
import '../../controllers/QuizController.dart';
import '../../models/question.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/QuizService.dart';

class CreateQuizPage extends StatefulWidget{

   const CreateQuizPage({
     super.key,
});

   @override
   State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final PageController _pageController = PageController();
  final QuizController _controller = QuizController(ImgUploadService(), QuizService(),);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.initEmptyQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _goToNextPage(int index){
    final msg = _controller.isCurrentQuestionValid(index);
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    if (index == _controller.questions.length - 1) {
      setState(() {
        _controller.questions.add(
            Question(
              questionId: DateTime.now().millisecondsSinceEpoch.toString(),
              questionText: '',
              correctAnswerIndex: 0,
              options: List.filled(4, ''),
            )
        );
      });
    }
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  /// lưu quiz
  void _saveQuiz(int index) async{
    final msg = _controller.isCurrentQuestionValid(index);
    if (msg.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }

    setState(() {
      isLoading = true;
    });

    await _controller.saveQuiz();
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lưu quiz thành công")));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => QuizScreen()),
          (Route<dynamic> route) => false,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create a Quiz'),
      body: Stack(
        children: [
          Padding(
           padding: const EdgeInsets.all(12.0),
           child: PageView.builder(
             controller: _pageController,
             physics: NeverScrollableScrollPhysics(),
             itemCount: _controller.questions.length +1,
             itemBuilder:(context, index){
             if(index == 0){
              return _buildFirstPage();
             }else{
              return _buildQuestionForm(index -1);
             }
          }
          ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
      ),
    );
  }

  Widget _buildFirstPage(){
    return Padding(
        padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  'Title Of Quiz',
                   textAlign: TextAlign.left,
                   style: TextStyle(fontSize: 20, color: Color(0xFF660000))
                 ),
                 SizedBox(height: 10,),
                 _buildInputField(
                   'Enter the title',
                   _titleController
                  ),
                 SizedBox(height: 30),
                 Text(
                  'Topic Of Quiz:',
                  style: TextStyle(fontSize: 20, color: Color(0xFF660000))
                 ),
                 SizedBox(height: 10,),
                 _buildInputField(
                     'Enter the topic',
                     _typeController),
                 SizedBox(height: 40),
                 Align(
                   alignment: Alignment.center,
                   child: CustomButton(
                       text: "Next",
                       textColor: Colors.white,
                       gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)],
                       onPressed: (){
                         if (_titleController.text.isEmpty || _typeController.text.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")));
                         } else {
                           _controller.setQuizInfo(
                               title: _titleController.text,
                               topic: _typeController.text,
                           );
                           _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                         }
                       }
                   ),
                 )
              ],
         ),
    );
  }

  Widget _buildQuestionForm(int index) {
    Question question = _controller.questions[index];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question ${index + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
              'Question content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            TextField(
              onChanged: (value) => question.questionText = value,
              controller: TextEditingController(text: question.questionText),
            ),
            SizedBox(height: 20,),
            _buildMediaPicker(index, question),
            SizedBox(height: 12),
            Text(
              'Enter the answers, choose the correct answer first!',
              style: TextStyle(fontSize: 15),
            ),
            for (int i = 0; i < 4; i++)
              RadioListTile<int>(
                title: TextField(
                  decoration: InputDecoration(labelText: "Answer ${i + 1}"),
                  onChanged: (value) => question.options[i] = value ?? '',
                  controller: TextEditingController(text: question.options[i]),
                ),
                value: i,
                groupValue: question.correctAnswerIndex,
                onChanged: (value) => setState(() => question.correctAnswerIndex = value!),
              ),
            SizedBox(height: 16),
            Row(
              children: [
                AbsorbPointer(
                  absorbing: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.6 : 1.0,
                    child: CustomButton(
                      text: " Back",
                      textColor: Colors.white,
                      gradientColors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      width: 170,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                AbsorbPointer(
                  absorbing: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.6 : 1.0,
                    child: CustomButton(
                      text: "Next ",
                      textColor: Colors.white,
                      gradientColors: [Color(0xFFE53935), Color(0xFFFF7043)],
                      onPressed: () => _goToNextPage(index),
                      width: 170,
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 20),
            /// button save
            if (_controller.questions.length >= 1)
              AbsorbPointer(
                absorbing: isLoading,
                child: Opacity(
                  opacity: isLoading ? 0.6 : 1.0,
                  child: CustomButton(
                    text: isLoading ? "Saving..." : "Save Quiz",
                    textColor: Colors.white,
                    gradientColors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                    onPressed: () async {
                          DialogHelper.showConfirmDialog(
                             context: context,
                             title: "Add new quiz?",
                             message: "Are you sure to add a new quiz?",
                             confirmText: "Add",
                             onConfirm: () => _saveQuiz(index),
                          );
                       },
                    width: double.infinity,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hintText, TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
      ),
      controller: controller,
    );
  }

  Widget _buildMediaPicker(int index, Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select illustration/video', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
         if (question.selectedMediaFile != null)
          question.mediaType == 'image'
              ? Image.memory(question.selectedMediaFile!, height: 150)
              : Column(
               children: [
                 Icon(Icons.videocam, size: 50),
                 Text("Video selected"),
            ],
          ),

        SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
             onPressed: () async {
             final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

             if (picked != null) {
              final bytes = await picked.readAsBytes();

              final updated = Question(
                questionId: question.questionId,
                questionText: question.questionText,
                options: question.options,
                correctAnswerIndex: question.correctAnswerIndex,
                selectedMediaFile: bytes,
                selectedMediaName: picked.name,
                mediaType: 'image',
              );
              setState(() {
                _controller.updateQuestion(index, updated);
              });
            }
             },
             icon: Icon(Icons.image),
             label: Text('Select illustration'),
           ),
           SizedBox(width: 10),

          ElevatedButton.icon(
          onPressed: () async {
            final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
            if (picked != null) {
              final bytes = await picked.readAsBytes();
              final updated = Question(
                questionId: question.questionId,
                questionText: question.questionText,
                options: question.options,
                correctAnswerIndex: question.correctAnswerIndex,
                selectedMediaFile: bytes,
                selectedMediaName: picked.name,
                mediaType: 'video',
              );
              setState(() {
                _controller.updateQuestion(index, updated);
              });
            }
          },
          icon: Icon(Icons.videocam),
          label: Text('Pick Video'),
        ),
      ],
    ),
    ],
    );
  }

}

