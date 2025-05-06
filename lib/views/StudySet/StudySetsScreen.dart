import 'package:flutter/material.dart';
import '../../services/StudySetService.dart';
import '../Home/HomeScreen.dart';
import 'NewStudySetScreen.dart';
import 'StudySetDetailScreen.dart';

class StudySetsPage extends StatefulWidget {
  @override
  _StudySetsPageState createState() => _StudySetsPageState();
}

class _StudySetsPageState extends State<StudySetsPage> {
  final StudySetService studySetService = StudySetService();
  List<Map<String, dynamic>> studySets = [];
  bool isLoading = true;

  final List<Color> lastestColors = [
    Color(0xFF40A6FF),
    Color(0xFFFF5C5C),
    Color(0xFFFF721A),
    Color(0xFFFF7996),
  ];

  @override
  void initState() {
    super.initState();
    fetchStudySets();
  }

  Future<void> fetchStudySets() async {
    try {
      final data = await studySetService.getListStudySet();
      setState(() {
        studySets = data;
        isLoading = false;
      });
    } catch (e) {
      print("Lỗi khi tải dữ liệu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          "Study Set",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.bookmark, color: Colors.purple),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lastest", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: studySets.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    _buildLastestCard(studySets[index], index),
              ),
            ),
            SizedBox(height: 20),
            Text("All Study Sets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.85,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: studySets.map((set) => _buildStudyCard(set)).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () async {
          // Mở trang tạo mới, sau khi tạo xong thì refresh lại danh sách
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudySetScreen()),
          );
          fetchStudySets(); // reload sau khi quay về
        },
      ),
    );
  }

  Widget _buildLastestCard(Map<String, dynamic> set, int index) {
    final color = lastestColors[index % lastestColors.length];
    return Container(
      width: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "Words",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Take Quiz",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.white),
              SizedBox(width: 6),
              Text(
                "Theo ${set['createBy'] ?? '---'}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStudyCard(Map<String, dynamic> set) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudySetDetailScreen(studySetId: set['docId']),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/icons/logo.png", height: 40),
            SizedBox(height: 8),
            Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(set["title"] ?? ''),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("Theo ${set["createBy"] ?? '---'}", style: TextStyle(fontSize: 12)),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text("12 likes", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Icon(Icons.bookmark, color: Colors.purple, size: 16),
              ],
            )
          ],
        ),
      ),
    );
  }

}
