import 'package:flutter/material.dart';
import '../../controllers/DictionaryController.dart';
import './ResultSearchPage.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom/CustomAppBar.dart';

class DictionaryScreen extends StatelessWidget {
  DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DictionaryController(),
      child: Scaffold(
        appBar: CustomAppBar(title: "Dictionary"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Consumer<DictionaryController>(
            builder: (context, controller, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.grey),
                      onPressed: controller.search,
                    ),
                    hintText: "Search",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => controller.search(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Search Results",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                if(controller.results.isEmpty)
                   const Text("Do not have any results"),
                if(controller.results.isNotEmpty)
                  ...controller.results.map((item) => _buildWordItem(
                  context,
                  item['keyword'],
                  description: item['description'],
                  videoUrl: item['videoUrl'],
                 )).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordItem(BuildContext context, String word, {String? description, String? videoUrl}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(1, 1))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(word, style: const TextStyle(fontSize: 16)),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.orange),
            onPressed: () {
              if (videoUrl != null && description != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultSearchPage( keyWord: word, videoUrl: videoUrl, description: description),
                  ),
                );
                debugPrint(word);
                debugPrint(description);
                debugPrint(videoUrl);
              }
            },
          ),
        ],
      ),
    );
  }

}
