import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KitchenPage extends StatelessWidget {
  const KitchenPage({super.key});

  //  update() สถานะ
  void _finishOrder(String docId) {
    FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'status': 'served', // เปลี่ยนสถานะเป็น "เสิร์ฟแล้ว" (ข้อมูลยังอยู่ครบ)
    });
  }

  // ฟังก์ชันจัดกลุ่มรายการอาหาร
  Map<String, int> _groupItems(List<dynamic> items) {
    Map<String, int> grouped = {};
    for (var item in items) {
      if (grouped.containsKey(item)) {
        grouped[item] = grouped[item]! + 1;
      } else {
        grouped[item.toString()] = 1;
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการอาหารที่ต้องทำ 👨‍🍳"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'waiting')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: Colors.grey,
                  ),
                  Text(
                    "เคลียร์ออเดอร์หมดแล้วครับ!",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              var data = order.data() as Map<String, dynamic>;

              String table = data['table'] ?? 'ไม่ระบุโต๊ะ';
              List<dynamic> items = data['items'] ?? [];

              Map<String, int> groupedItems = _groupItems(items);

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            table,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(Icons.soup_kitchen, color: Colors.white70),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: groupedItems.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "x ${entry.value}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const Divider(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _finishOrder(order.id),
                          icon: const Icon(Icons.check),
                          label: const Text(
                            "ปรุงเสร็จแล้ว (เสิร์ฟ)",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
