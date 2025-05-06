import 'package:flutter/material.dart';
import '../../models/StudyItem.dart';
import '../../controllers/StudyItemController.dart';

class StudyItemModal {
  final StudyItemController _itemController = StudyItemController();

  void showAddItemModal(BuildContext context, Function(StudyItem) onAddItem) {
    TextEditingController searchController = TextEditingController();
    List<StudyItem> filteredItems = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> performSearch(String keyword) async {
              final results = await _itemController.searchItems(keyword);
              setState(() {
                filteredItems = results.cast<StudyItem>();
              });
            }

            // Lần đầu load toàn bộ hoặc keyword rỗng
            if (filteredItems.isEmpty) {
              performSearch('');
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.orange),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text("Tìm và thêm mục", style: TextStyle(color: Colors.black)),
                    centerTitle: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        performSearch(value.trim());
                      },
                      decoration: InputDecoration(
                        hintText: "Nhập từ khoá...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(child: Text("Không tìm thấy kết quả"))
                        : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          leading: Icon(Icons.volume_up, color: Colors.black54),
                          title: Text(item.keyword),
                          trailing: IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.blue),
                            onPressed: () {
                              onAddItem(item);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}