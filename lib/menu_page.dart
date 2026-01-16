import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'order_history_page.dart';

class MenuPage extends StatefulWidget {
  final String tableNumber;

  const MenuPage({super.key, required this.tableNumber});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> _cart = [];

  final Map<String, List<MenuItem>> menuCategories = {
    'เนื้อสัตว์ & ทะเล': [
      MenuItem(
        name: 'หมูสามชั้นสไลด์',
        imageUrl: 'https://o2o-static.lotuss.com/products/107486/22980784.jpg',
      ),
      MenuItem(
        name: 'หมูสันนอกสไลด์',
        imageUrl:
            'https://sooktookkum.com/wp-content/uploads/2019/07/%E0%B8%AA%E0%B8%B1%E0%B8%99%E0%B8%84%E0%B8%AD%E0%B8%AA%E0%B9%84%E0%B8%A5%E0%B8%94%E0%B9%8C.jpg',
      ),
      MenuItem(
        name: 'เนื้อวากิวสไลด์',
        imageUrl:
            'https://blog.hungryhub.com/wp-content/uploads/2018/10/Japanese-Wagyu.jpg',
      ),
      MenuItem(
        name: 'เนื้อใบพายสไลด์',
        imageUrl:
            'https://images.mango-prod.siammakro.cloud/product-images/7115327111363-784951e5-9d3b-4ef7-85a9-24c066814db5.jpeg',
      ),
      MenuItem(
        name: 'กุ้งแก้ว',
        imageUrl:
            'https://e7.pngegg.com/pngimages/125/349/png-clipart-shrimp-dish-pandalus-borealis-shrimp-seafood-shrimp-food-animals.png',
      ),
    ],
    'ผัก & ของทานเล่น': [
      MenuItem(
        name: 'เห็ดเข็มทอง',
        imageUrl:
            'https://i.pinimg.com/474x/12/97/48/1297480cfa34bdc13e5d97f4494b5122.jpg',
      ),
      MenuItem(
        name: 'ผักบุ้ง',
        imageUrl:
            'https://img.wongnai.com/p/1920x0/2021/08/18/66b7e7f2d07c4e11bacac141e96f9655.jpg',
      ),
      MenuItem(
        name: 'ไก่ทอด',
        imageUrl:
            'https://i.pinimg.com/736x/62/86/b4/6286b4351437be3f92540e6f72fb64d4.jpg',
      ),
      MenuItem(
        name: 'เฟรนซ์ฟราย',
        imageUrl:
            'https://marketplace.canva.com/MACl4lVv9s4/2/thumbnail_large-1/canva-plate-of-french-fries-cutout-MACl4lVv9s4.png',
      ),
      MenuItem(
        name: 'เกี๊ยวทอด',
        imageUrl: 'https://o2o-static.lotuss.com/products/107486/22980784.jpg',
      ),
    ],
    'เครื่องดื่ม & ของหวาน': [
      MenuItem(
        name: 'นํ้าเปล่า',
        imageUrl: 'https://www.bar24store.com/contents/products/sizes/43.png',
      ),
      MenuItem(
        name: 'นํ้าโค้ก',
        imageUrl:
            'https://gda.thai-tba.or.th/wp-content/uploads/2018/07/coke-rgb-422-ml.png',
      ),
      MenuItem(
        name: 'นํ้าชา',
        imageUrl:
            'https://img.th.my-best.com/product_images/6f6ecf073ba09a669ebd0a3bcdcfc31b.png?ixlib=rails-4.3.1&q=70&lossless=0&w=800&h=800&fit=clip&s=746496b04c89e546734a6f9af2fd1225',
      ),
      MenuItem(
        name: 'แตงโม',
        imageUrl:
            'https://img.freepik.com/premium-photo/png-fresh-juicy-summer-fruit-watermelon-isolated-white-background_185193-126718.jpg',
      ),
      MenuItem(
        name: 'ไอศกรีมกะทิ',
        imageUrl:
            'https://img.wongnai.com/p/400x0/2022/02/21/3f6dc44271db4362a95a0768ad616d12.jpg',
      ),
    ],
  };

  int _getQuantity(String item) {
    return _cart.where((e) => e == item).length;
  }

  void _increaseItem(String item) {
    setState(() {
      _cart.add(item);
    });
  }

  void _decreaseItem(String item) {
    setState(() {
      _cart.remove(item);
    });
  }

  void _goToCart() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartPage(tableNumber: widget.tableNumber, cartItems: _cart),
      ),
    );

    if (result == true) {
      setState(() {
        _cart.clear();
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: menuCategories.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("เมนู - ${widget.tableNumber}"),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrderHistoryPage(tableNumber: widget.tableNumber),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: "เนื้อสัตว์"),
              Tab(icon: Icon(Icons.grass), text: "ผัก/ทานเล่น"),
              Tab(icon: Icon(Icons.local_drink), text: "เครื่องดื่ม/ของหวาน"),
            ],
          ),
        ),
        body: TabBarView(
          children: menuCategories.values.map((items) {
            //  GridView (ตาราง)
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // โชว์แถวละ 2 เมนู
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                MenuItem menuItem = items[index];
                String menuName = menuItem.name;
                int quantity = _getQuantity(menuName);

                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              menuItem.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                            if (quantity > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // 2. ส่วนชื่อและปุ่มกด (อยู่ด้านล่าง)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              menuName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow
                                  .ellipsis, // ถ้าชื่อยาวให้ตัดเป็น ...
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            // ปุ่มกด
                            quantity == 0
                                ? SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () => _increaseItem(menuName),
                                      icon: const Icon(
                                        Icons.add_shopping_cart,
                                        size: 18,
                                      ),
                                      label: const Text("สั่งเลย"),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ปุ่มลบ
                                      InkWell(
                                        onTap: () => _decreaseItem(menuName),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.remove,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      // ตัวเลขตรงกลาง
                                      Text(
                                        "$quantity",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      // ปุ่มเพิ่ม
                                      InkWell(
                                        onTap: () => _increaseItem(menuName),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: _cart.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: _goToCart,
                backgroundColor: Colors.green,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  "ตะกร้า (${_cart.length})",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : null,
      ),
    );
  }
}

class MenuItem {
  final String name;
  final String imageUrl;

  MenuItem({required this.name, required this.imageUrl});
}
