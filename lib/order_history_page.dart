import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryPage extends StatelessWidget {
  final String tableNumber;

  const OrderHistoryPage({super.key, required this.tableNumber});

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return "กำลังส่ง...";
    DateTime dt = timestamp.toDate();
    String hour = dt.hour.toString().padLeft(2, '0');
    String minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute น.";
  }

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
        title: Text("ประวัติการสั่ง ($tableNumber)"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where(
              'table',
              isEqualTo: tableNumber,
            ) // ⚠️ ต้องไม่มี .where status นะครับ
            .orderBy('timestamp', descending: true)
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
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  Text(
                    "ยังไม่มีประวัติการสั่งครับ",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              List<dynamic> items = data['items'] ?? [];
              Timestamp? timestamp = data['timestamp'];

              // ดึงสถานะมาเช็ค (ถ้าไม่มีให้เป็น waiting)
              String status = data['status'] ?? 'waiting';
              bool isServed = status == 'served';

              Map<String, int> groupedItems = _groupItems(items);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                // เปลี่ยนสีขอบการ์ดตามสถานะ
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isServed ? Colors.green : Colors.orange,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "เวลา: ${_formatTime(timestamp)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          // ป้ายสถานะ
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isServed ? Colors.green : Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isServed
                                  ? "เสิร์ฟแล้ว ✅"
                                  : "กำลังเตรียมเสิร์ฟ 👨‍🍳",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      ...groupedItems.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: const TextStyle(fontSize: 16)),
                              Text(
                                "x${e.value}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
