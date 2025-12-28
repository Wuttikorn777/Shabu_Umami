import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillPage extends StatefulWidget {
  final String tableNumber;

  const BillPage({super.key, required this.tableNumber});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  final double pricePerHead = 299.0;
  final TextEditingController _customerCountController =
      TextEditingController();
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _customerCountController.text = "1";
    calculateTotal();
  }

  void calculateTotal() {
    setState(() {
      int count = int.tryParse(_customerCountController.text) ?? 0;
      totalAmount = count * pricePerHead;
    });
  }

  Future<void> clearTable() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันการชำระเงิน"),
        content: Text(
          "รับเงินยอด ${totalAmount.toStringAsFixed(0)} บาท เรียบร้อยแล้วใช่ไหม?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("ยกเลิก"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("รับเงินเรียบร้อย"),
          ),
        ],
      ),
    );

    if (confirm) {
      var collection = FirebaseFirestore.instance.collection('orders');
      var snapshot = await collection
          .where('table', isEqualTo: widget.tableNumber)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ ชำระเงินและเคลียร์โต๊ะเรียบร้อย!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เช็คบิล ${widget.tableNumber}"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('table', isEqualTo: widget.tableNumber)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                List<String> allItems = [];
                for (var doc in docs) {
                  allItems.addAll(List<String>.from(doc['item']));
                }
                if (allItems.isEmpty) {
                  return const Center(child: Text("ไม่มีรายการอาหาร"));
                }
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      "รายการที่สั่งทานไป:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...allItems.map(
                      (item) =>
                          Text("- $item", style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _customerCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "จำนวนคน",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => calculateTotal(),
                ),
                const SizedBox(height: 20),
                Text(
                  "รวม: ${totalAmount.toStringAsFixed(0)} ฿",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: clearTable,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("รับเงิน & เคลียร์โต๊ะ"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
