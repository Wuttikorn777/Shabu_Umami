import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kitchen_page.dart';
import 'cashier_page.dart';
import 'menu_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // --- ฟังก์ชันเลือกโต๊ะ  ---
  void _showTableSelection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("เลือกโต๊ะของคุณ"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          children: [
            for (int i = 1; i <= 5; i++)
              SimpleDialogOption(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // ไปที่หน้า MenuPage พร้อมส่งเบอร์โต๊ะ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuPage(tableNumber: 'โต๊ะ $i'),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.table_restaurant,
                        color: Color(0xFFFF9F1C),
                      ),
                      const SizedBox(width: 15),
                      Text("โต๊ะ $i", style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // พื้นหลังสีครีมไข่ไก่
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- ส่วนที่ 1: หัวข้อร้าน ---
            const Text(
              'SHABU UMAMI',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD32F2F), // สีแดงเข้ม
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              'อูมามิทุกคำที่คุณสัมผัสได้',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 20), // เว้นระยะห่างหน่อย
            // --- ส่วนที่ 2: หม้อชาบูตรงกลาง  ---
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    'https://i.pinimg.com/1200x/50/1e/2f/501e2f1c60bef6e0f1ba7c11e4cf0313.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white,
                        child: const Center(
                          child: Icon(
                            Icons.soup_kitchen,
                            size: 80,
                            color: Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---  3 หมวดหมู่  ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. ปุ่มลูกค้า -> เรียกฟังก์ชันเลือกโต๊ะ
                  _buildMenuCard(
                    context,
                    title: 'ลูกค้า (สั่งอาหาร)',
                    subtitle: 'Customer Order',
                    icon: Icons.restaurant_menu,
                    color: const Color(0xFFFF9F1C), // สีส้ม
                    onTap: () {
                      _showTableSelection(context); // เรียกฟังก์ชันเดิม
                    },
                  ),
                  const SizedBox(height: 15),

                  // 2. ปุ่มครัว -> ไปหน้า KitchenPage
                  _buildMenuCard(
                    context,
                    title: 'ห้องครัว (จอพ่อครัว)',
                    subtitle: 'Kitchen Monitor',
                    icon: Icons.soup_kitchen,
                    color: const Color(0xFF2EC4B6), // สีเขียวมิ้นท์
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KitchenPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  // 3. ปุ่มแคชเชียร์ -> ไปหน้า CashierPage
                  _buildMenuCard(
                    context,
                    title: 'เคลียร์โต๊ะ (แคชเชียร์)',
                    subtitle: 'Reset Table',
                    icon: Icons.point_of_sale,
                    color: const Color(0xFFFF4757), // สีแดง
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CashierPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget ช่วยสร้างปุ่มสวยๆ
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // พื้นหลังจางๆ
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: GoogleFonts.kanit().fontFamily,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: GoogleFonts.kanit().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
