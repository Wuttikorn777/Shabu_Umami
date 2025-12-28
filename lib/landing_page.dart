import 'package:flutter/material.dart';
import 'main.dart';
import 'kitchen_page.dart';
import 'cashier_page.dart';
import 'menu_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // ฟังก์ชันเลือกโต๊ะก่อนเข้าเมนู
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
                  Navigator.pop(context);

                  // ไปที่หน้า MenuPage ใหม่ พร้อมส่งเบอร์โต๊ะ
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

            // 1. ปุ่มสำหรับลูกค้า
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.restaurant_menu, size: 30),
                label: const Text(
                  "ลูกค้า (สั่งอาหาร)",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                // 👈 2. แก้ตรงนี้ (ลบวงเล็บที่เกินออก)
                onPressed: () => _showTableSelection(context),
              ),
            ),

            const SizedBox(height: 20),

            // 2. ปุ่มสำหรับห้องครัว
            SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.soup_kitchen, size: 30),
                label: const Text(
                  "ห้องครัว (รับออเดอร์)",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KitchenPage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 3. ปุ่มสำหรับแคชเชียร์
            SizedBox(
              width: 280,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.point_of_sale, size: 30),
                label: const Text(
                  "เคลียร์โต๊ะ (Reset)",
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CashierPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
