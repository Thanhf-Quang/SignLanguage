import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'views/detection_screen.dart';
import 'views/edit_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        centerTitle: true,
      ),
      body: Center(

          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Demo để test 2 tính năng thôi",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50.0),
                ElevatedButton(
                  onPressed: () async {
                    // Chờ lấy danh sách camera trước khi mở DetectionScreen
                    WidgetsFlutterBinding.ensureInitialized();
                    cameras = await availableCameras();

                    // Chuyển sang DetectionScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetectionScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Bắt đầu nhận diện',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                  },
                  child: Text('Trang Cá Nhân', style: TextStyle(fontSize: 18)),
                ),
              ]
          )
      ),
    );
  }
}
