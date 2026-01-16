import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final int buffetPrice = 299;

  final String promptPayId = "081-234-5678";

  // ฟังก์ชันเช็คบิล (ลบออเดอร์ของโต๊ะนั้น)
  void _closeTable(String tableNumber) async {
    // ดึงออเดอร์ของโต๊ะนั้นมาทั้งหมดเพื่อลบ
    var collection = FirebaseFirestore.instance.collection('orders');
    var snapshot = await collection
        .where('table', isEqualTo: tableNumber)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ปิด $tableNumber เรียบร้อย! รับลูกค้าใหม่ได้เลย ✅'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  // แสดง Dialog สรุปยอดเงิน (แบบบุฟเฟต์ + QR Code)
  void _showBuffetBillDialog(String tableNumber, List<String> allItems) {
    // นับจำนวนรายการ (เอาไว้ดูว่าสั่งอะไรไปเท่าไหร่)
    Map<String, int> summary = {};
    for (var item in allItems) {
      summary[item] = (summary[item] ?? 0) + 1;
    }

    // ตัวแปรสำหรับเก็บจำนวนคน
    int numberOfPeople = 1;
    TextEditingController peopleController = TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int totalAmount = numberOfPeople * buffetPrice;

            return AlertDialog(
              title: Text('เช็คบิล  $tableNumber (บุฟเฟต์) 🥘'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "จำนวนลูกค้า (ท่าน):",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: peopleController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "กรอกจำนวนคน",
                          prefixIcon: Icon(Icons.people),
                        ),
                        onChanged: (value) {
                          setState(() {
                            numberOfPeople = int.tryParse(value) ?? 0;
                          });
                        },
                      ),

                      const SizedBox(height: 15),
                      const Divider(),

                      // 2. สรุปรายการอาหาร (เช็คของ)
                      ExpansionTile(
                        title: Text(
                          "รายการอาหารที่สั่ง (${allItems.length} จาน)",
                        ),
                        children: [
                          Container(
                            height: 100, //
                            color: Colors.grey[100],
                            child: ListView(
                              children: summary.entries.map((e) {
                                return ListTile(
                                  dense: true,
                                  title: Text(e.key),
                                  trailing: Text("x${e.value}"),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      // 3. ยอดรวมเงิน
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ยอดสุทธิ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "$numberOfPeople x $buffetPrice",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "$totalAmount บาท",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // 4. 🔥 QR Code สำหรับลูกค้าสแกน
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "สแกนจ่ายเงิน",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 5),
                              QrImageView(
                                data:
                                    "PromptPay:$promptPayId\nAmount:$totalAmount", // ข้อมูล QR
                                version: QrVersions.auto,
                                size: 180.0, // ขนาด QR
                              ),
                              Text(
                                "พร้อมเพย์: $promptPayId",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ยกเลิก"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () => _closeTable(tableNumber),
                  child: const Text("รับเงินเรียบร้อย (เคลียร์โต๊ะ)"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cashier - บุฟเฟต์ 299.- 💸")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          // รวบรวมข้อมูล: โต๊ะไหนมีรายการบ้าง
          Map<String, List<String>> tableOrders = {};

          for (var doc in snapshot.data!.docs) {
            String table = doc['table'];
            List<dynamic> items = doc['items'];

            if (!tableOrders.containsKey(table)) {
              tableOrders[table] = [];
            }
            tableOrders[table]!.addAll(items.map((e) => e.toString()));
          }

          List<String> activeTables = tableOrders.keys.toList()..sort();

          if (activeTables.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_mall_directory,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "ยังไม่มีลูกค้าครับ",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.85,
            ),
            itemCount: activeTables.length,
            itemBuilder: (context, index) {
              String table = activeTables[index];
              int itemCount = tableOrders[table]!.length;

              return GestureDetector(
                onTap: () => _showBuffetBillDialog(table, tableOrders[table]!),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.deepOrange.shade100,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          255,
                          21,
                          0,
                        ).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.table_restaurant,
                          size: 40,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        table,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "$itemCount จาน",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "คิดเงิน",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
