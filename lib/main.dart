import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'landing_page.dart'; // <--- สำคัญมาก! บรรทัดนี้จะดึงหน้าสวยๆ มาแสดง

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ถ้ายังไม่ได้ตั้งค่า Firebase ให้ใส่ // หน้าบรรทัด await ข้างล่างนี้ก่อนนะครับ
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF512F)),
        useMaterial3: true,
        // ใช้ฟอนต์ Kanit ทั้งแอป
        textTheme: GoogleFonts.kanitTextTheme(),
      ),
      // ตรงนี้คือจุดเชื่อม! เรียกใช้ LandingPage จากไฟล์ landing_page.dart
      home: const LandingPage(),
    );
  }
}
