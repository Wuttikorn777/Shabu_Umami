import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'menu_page.dart';
import 'kitchen_page.dart';
import 'cashier_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCV2zMq6H8ATDeaxIVQSH0YBcXOqwwmIcY",
      authDomain: "shabu-umami-db.firebaseapp.com",
      projectId: "shabu-umami-db",
      storageBucket: "shabu-umami-db.firebasestorage.app",
      messagingSenderId: "1017686811958",
      appId: "1:1017686811958:web:6e1aecbd62897467d03f97",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shabu Umami',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        textTheme: GoogleFonts.kanitTextTheme(Theme.of(context).textTheme),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // ฟังก์ชันเลือกโต๊ะก่อนเข้าหน้าเมนู
  void _showTableSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("เลือกโต๊ะของคุณ"),
          children: [
            for (int i = 1; i <= 5; i++)
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 24,
                ),
                onPressed: () {
                  Navigator.pop(context); // ปิด Dialog
                  // ไปที่หน้า MenuPage พร้อมส่งเบอร์โต๊ะไปด้วย
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPage(tableNumber: 'โต๊ะ $i'),
                    ),
                  );
                },
                child: Text("โต๊ะ $i", style: const TextStyle(fontSize: 18)),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hot_tub_rounded,
              size: 100,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              "Shabu Umami System",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const Text(
              "กรุณาเลือกโหมดการใช้งาน",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 50),

            // 1. ปุ่มลูกค้า (กดแล้วให้เลือกโต๊ะก่อน)
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.restaurant_menu),
                label: const Text(
                  "ลูกค้า (สั่งอาหาร)",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () =>
                    _showTableSelection(context), // เรียกฟังก์ชันเลือกโต๊ะ
              ),
            ),
            const SizedBox(height: 20),

            // 2. ปุ่มครัว
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.soup_kitchen),
                label: const Text(
                  "ห้องครัว (จอพ่อครัว)",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KitchenPage()),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. ปุ่มแคชเชียร์
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete_sweep),
                label: const Text(
                  "เคลียร์โต๊ะ (Reset)",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CashierPage()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
