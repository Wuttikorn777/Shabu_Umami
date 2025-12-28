import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final String tableNumber;
  final List<String> cartItems; // รับรายการทั้งหมดมาจากหน้าเมนู

  const CartPage({
    super.key,
    required this.tableNumber,
    required this.cartItems,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, int> _groupedItems = {};

  @override
  void initState() {
    super.initState();
    _groupItems();
  }

  void _groupItems() {
    for (var item in widget.cartItems) {
      if (_groupedItems.containsKey(item)) {
        _groupedItems[item] = _groupedItems[item]! + 1;
      } else {
        _groupedItems[item] = 1;
      }
    }
  }

  void _incrementQuantity(String item) {
    setState(() {
      _groupedItems[item] = _groupedItems[item]! + 1;
    });
  }

  void _decrementQuantity(String item) {
    setState(() {
      if (_groupedItems[item]! > 1) {
        _groupedItems[item] = _groupedItems[item]! - 1;
      } else {
        _groupedItems.remove(item);
      }
    });
  }

  // ฟังก์ชันยืนยันออเดอร์
  Future<void> _confirmOrder() async {
    if (_groupedItems.isEmpty) return;

    List<String> finalOrderList = [];
    _groupedItems.forEach((key, quantity) {
      for (int i = 0; i < quantity; i++) {
        finalOrderList.add(key);
      }
    });

    await FirebaseFirestore.instance.collection('orders').add({
      'table': widget.tableNumber,
      'items': finalOrderList,
      'status': 'waiting',
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ส่งออเดอร์เรียบร้อย! 🍲')));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = 0;
    _groupedItems.forEach((_, qty) => totalItems += qty);

    return Scaffold(
      appBar: AppBar(
        title: Text("ตะกร้า (${widget.tableNumber})"),
        backgroundColor: Colors.orange,
      ),
      body: _groupedItems.isEmpty
          ? const Center(
              child: Text(
                "ตะกร้าว่างเปล่า",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _groupedItems.length,
              itemBuilder: (context, index) {
                String key = _groupedItems.keys.elementAt(index);
                int quantity = _groupedItems[key]!;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ชื่ออาหาร
                        Expanded(
                          child: Text(
                            key,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        // ปุ่ม ลด - จำนวน - เพิ่ม
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _decrementQuantity(key),
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "$quantity", // แสดงจำนวน x3, x4
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _incrementQuantity(key),
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.orange[50],
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: _groupedItems.isEmpty ? null : _confirmOrder,
          icon: const Icon(Icons.check_circle, size: 30),
          label: Text(
            "ยืนยันสั่ง ($totalItems จาน)",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
