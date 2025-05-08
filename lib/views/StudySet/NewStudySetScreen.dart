import 'package:flutter/material.dart';
import '../../models/StudyItem.dart';
import '../../services/StudySetService.dart';
import 'StudyItemModal.dart';

class StudySetScreen extends StatefulWidget {
  @override
  StudySetScreenState createState() => StudySetScreenState();
}

class StudySetScreenState extends State<StudySetScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final StudySetService studySetService = StudySetService();

  bool isPublic = true;
  List<StudyItem> items = []; // Danh sách các mục học
  final StudyItemModal studyItemModal = StudyItemModal(); // Khởi tạo modal

  void addItem(StudyItem newItem) {
    if (!items.any((i) => i.id == newItem.id)) {
      setState(() {
        items.add(newItem);
      });
    }
  }

  Future<void> handleSaveStudySet() async {
    final title = titleController.text.trim();
    final category = categoryController.text.trim();

    if (title.isEmpty || category.isEmpty || items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    try {
      await studySetService.saveStudySet(
        title: title,
        category: category,
        studyItemIds: items.map((e) => e.id).toList(),
        isPublic: isPublic,
      );
      print('onclick Hoan tất');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lưu thành công!")),
      );

      await Future.delayed(Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi lưu: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tạo bộ bài học",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: handleSaveStudySet,
            child: Text("Hoàn tất", style: TextStyle(color: Colors.blue, fontSize: 16)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField("Tên bộ bài học", titleController),
            buildTextField("Danh mục", categoryController),
            buildPrivacySwitch(),
            SizedBox(height: 10),
            Text("Mục", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return buildLessonItem(items[index]);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                studyItemModal.showAddItemModal(context, addItem);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text("Thêm mục", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildPrivacySwitch() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Công khai Bộ bài học của tôi", style: TextStyle(fontSize: 16)),
          Switch(
            value: isPublic,
            onChanged: (value) {
              setState(() {
                isPublic = value;
              });
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget buildLessonItem(StudyItem item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.volume_up, color: Colors.black54),
              SizedBox(width: 10),
              Text(item.keyword, style: TextStyle(fontSize: 16)),
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                items.removeWhere((i) => i.id == item.id);
              });
            },
          ),
        ],
      ),
    );
  }
}
