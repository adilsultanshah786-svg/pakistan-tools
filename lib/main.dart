import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PakistanToolsApp());
}

class PakistanToolsApp extends StatelessWidget {
  const PakistanToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}

class Product {
  final String title;
  final String brand;
  final double price;
  final String imageUrl;

  Product({
    required this.title,
    required this.brand,
    required this.price,
    required this.imageUrl,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String phone = "+923451333385";
  final String whatsapp = "923451333385";
  final String address = "College Road, Pakistan Tools, Vahowa";

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<Product> searchResults = [];
  bool isLoading = true;
  String selectedBrand = "ALL";
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLiveWebProducts();
  }

  // Internet se dono websites ka data fetch karne ka function
  Future<void> fetchLiveWebProducts() async {
    List<Product> loaded = [];

    // 1. TotalTool.pk se live products fetch karein
    try {
      final res = await http.get(
        Uri.parse("https://totaltool.pk/products.json?limit=50"),
        headers: {"User-Agent": "Mozilla/5.0"},
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List items = data['products'] ?? [];
        for (var item in items) {
          final title = item['title'] ?? '';
          final variants = item['variants'] as List?;
          double price = 0.0;
          if (variants != null && variants.isNotEmpty) {
            price = double.tryParse(variants[0]['price'].toString()) ?? 0.0;
          }
          final images = item['images'] as List?;
          String img = "";
          if (images != null && images.isNotEmpty) {
            img = images[0]['src'] ?? "";
          }

          loaded.add(Product(
            title: title,
            brand: "TOTAL",
            price: price,
            imageUrl: img,
          ));
        }
      }
    } catch (_) {}

    // Fallback Initial Stock agar network slow ho
    if (loaded.isEmpty) {
      loaded = [
        Product(
          title: "TOTAL 20V Lithium-Ion Drill (TDLI20024)",
          brand: "TOTAL",
          price: 14500,
          imageUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500",
        ),
        Product(
          title: "INGCO 750W Angle Grinder 115mm (AG750282)",
          brand: "INGCO",
          price: 7800,
          imageUrl: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500",
        ),
        Product(
          title: "WADFOW Claw Hammer 450g Heavy Duty",
          brand: "WADFOW",
          price: 1350,
          imageUrl: "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500",
        ),
        Product(
          title: "TOTAL Rotary Hammer SDS Plus 800W",
          brand: "TOTAL",
          price: 19500,
          imageUrl: "https://images.unsplash.com/photo-1581244277943-fe4a9c777189?w=500",
        ),
        Product(
          title: "INGCO Brushless Impact Driver 20V",
          brand: "INGCO",
          price: 21500,
          imageUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500",
        ),
        Product(
          title: "WADFOW Precision Screwdriver Set 24 Pcs",
          brand: "WADFOW",
          price: 2200,
          imageUrl: "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500",
        ),
      ];
    }

    setState(() {
      allProducts = loaded;
      filteredProducts = loaded;
      isLoading = false;
    });
  }

  void openWhatsApp([String? customMsg]) async {
    final msg = customMsg ?? "Assalam o Alaikum! Mujhe tools ke baare mein maloomat chahiye.";
    final uri = Uri.parse("https://wa.me/$whatsapp?text=${Uri.encodeComponent(msg)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void callPhone() async {
    final uri = Uri.parse("tel:$phone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void openMapLocation() async {
    final uri = Uri.parse("https://maps.google.com/?q=${Uri.encodeComponent(address)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void filterBrand(String brand) {
    setState(() {
      selectedBrand = brand;
      if (brand == "ALL") {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts.where((p) => p.brand.toUpperCase() == brand.toUpperCase()).toList();
      }
    });
  }

  void onSearch(String text) {
    final q = text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        searchResults = [];
      } else {
        searchResults = allProducts
            .where((p) => p.title.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ingcoCount = allProducts.where((p) => p.brand == "INGCO").length;
    final wadfowCount = allProducts.where((p) => p.brand == "WADFOW").length;
    final totalCount = allProducts.where((p) => p.brand == "TOTAL").length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE41E26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("PT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("PAKISTAN TOOLS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                Text("Premium Hardware - Vahowa", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: callPhone,
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            onChanged: onSearch,
                            decoration: const InputDecoration(
                              hintText: "Search tools, brands, items...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (searchCtrl.text.isNotEmpty) {
                              setState(() {
                                filteredProducts = List.from(searchResults);
                                searchResults = [];
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("GO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        )
                      ],
                    ),
                  ),
                ),

                // Live Suggestions
                if (searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: Column(
                      children: searchResults.take(6).map((item) => ListTile(
                        dense: true,
                        title: Text(item.title, maxLines: 1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        subtitle: Text("Rs. ${item.price.toInt()} (${item.brand})", style: const TextStyle(color: Colors.blue, fontSize: 11)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                        onTap: () {
                          searchCtrl.text = item.title;
                          setState(() {
                            filteredProducts = [item];
                            searchResults = [];
                          });
                        },
                      )).toList(),
                    ),
                  ),

                // 2. Hero Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(16),
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B1B1B), Color(0xFFC91414)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          child: Text("${allProducts.length}+ PRODUCTS", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("PAKISTAN HARDWARE - VAHOWA", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("BUILD WITH\nTHE BEST TOOLS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.1)),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => openWhatsApp("Assalam o Alaikum! Mujhe tools order karne hain."),
                        icon: const Icon(Icons.chat, size: 14, color: Colors.white),
                        label: const Text("ORDER ON WHATSAPP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                    ],
                  ),
                ),

                // 3. Trust Badges
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("✔ 100% Original", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                      Text("⚡ Fast Delivery", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                      Text("🛡 Trusted", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Shop By Brand
                _buildHeader("SHOP BY BRAND"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _brandBtn("INGCO", const Color(0xFFC91414), "$ingcoCount items"),
                      const SizedBox(width: 8),
                      _brandBtn("WADFOW", const Color(0xFFF39200), "$wadfowCount items"),
                      const SizedBox(width: 8),
                      _brandBtn("TOTAL", const Color(0xFF00758F), "$totalCount items"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Products Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeader("NEW ARRIVALS"),
                      TextButton(
                        onPressed: () => filterBrand("ALL"),
                        child: const Text("See All ›", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                ),

                // 6. Products Grid
                isLoading
                    ? const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, idx) {
                          final item = filteredProducts[idx];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.build, color: Colors.grey)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.brand, style: const TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
                                      Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text("Rs. ${item.price.toInt()}", style: const TextStyle(color: Color(0xFF00758F), fontWeight: FontWeight.w900, fontSize: 12)),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 28,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF25D366),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () => openWhatsApp("Assalam o Alaikum, mujhe khareedna hai:\n${item.title}\nPrice: Rs. ${item.price.toInt()}"),
                                          child: const Text("Order Now", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),

                const SizedBox(height: 18),

                // 7. Visit Shop Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("VISIT OUR SHOP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: openMapLocation,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(address, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: callPhone,
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text(phone, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                          label: const Text("WHATSAPP PE ORDER KAREIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          onPressed: () => openWhatsApp(),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),

          // Floating WhatsApp Action Button
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF25D366),
              onPressed: () => openWhatsApp(),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: Colors.red),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _brandBtn(String brand, Color color, String count) {
    return Expanded(
      child: GestureDetector(
        onTap: () => filterBrand(brand),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(brand, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(count, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text("BROWSE →", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String shopPhone = "+923451333385";
  final String waNumber = "923451333385";
  final String shopAddress = "College Road, Pakistan Tools, Vahowa";

  final List<ToolItem> allProducts = [
    ToolItem(
      title: "TOTAL 20V Cordless Lithium-Ion Drill (TDLI20024)",
      brand: "TOTAL",
      price: 14500,
      imgUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500",
    ),
    ToolItem(
      title: "INGCO 750W Angle Grinder 115mm (AG750282)",
      brand: "INGCO",
      price: 7800,
      imgUrl: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500",
    ),
    ToolItem(
      title: "WADFOW Claw Hammer 450g Heavy Duty",
      brand: "WADFOW",
      price: 1350,
      imgUrl: "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500",
    ),
    ToolItem(
      title: "TOTAL Rotary Hammer SDS Plus 800W",
      brand: "TOTAL",
      price: 19500,
      imgUrl: "https://images.unsplash.com/photo-1581244277943-fe4a9c777189?w=500",
    ),
    ToolItem(
      title: "INGCO Brushless Impact Driver 20V",
      brand: "INGCO",
      price: 21500,
      imgUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500",
    ),
    ToolItem(
      title: "WADFOW Precision Screwdriver Set 24 Pcs",
      brand: "WADFOW",
      price: 2200,
      imgUrl: "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500",
    ),
  ];

  List<ToolItem> displayProducts = [];
  List<ToolItem> searchResults = [];
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayProducts = List.from(allProducts);
  }

  void showContactDialog(String title, String detail, String actionType) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(detail, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void filterBrand(String brand) {
    setState(() {
      if (brand == "ALL") {
        displayProducts = List.from(allProducts);
      } else {
        displayProducts = allProducts.where((p) => p.brand.toUpperCase() == brand.toUpperCase()).toList();
      }
    });
  }

  void onSearch(String text) {
    final q = text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        searchResults = [];
      } else {
        searchResults = allProducts
            .where((p) => p.title.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE41E26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("PT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("PAKISTAN TOOLS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                Text("Premium Hardware - Vahowa", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: () => showContactDialog("Call Us", "Phone: $shopPhone", "CALL"),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            onChanged: onSearch,
                            decoration: const InputDecoration(
                              hintText: "Search tools, brands, items...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (searchCtrl.text.isNotEmpty) {
                              setState(() {
                                displayProducts = List.from(searchResults);
                                searchResults = [];
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("GO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        )
                      ],
                    ),
                  ),
                ),

                // Search Suggestions Dropdown
                if (searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: Column(
                      children: searchResults.map((item) => ListTile(
                        dense: true,
                        title: Text(item.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        subtitle: Text("Rs. ${item.price} (${item.brand})", style: const TextStyle(color: Colors.blue, fontSize: 11)),
                        onTap: () {
                          searchCtrl.text = item.title;
                          setState(() {
                            displayProducts = [item];
                            searchResults = [];
                          });
                        },
                      )).toList(),
                    ),
                  ),

                // 2. Hero Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(16),
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B1B1B), Color(0xFFC91414)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          child: const Text("500+ PRODUCTS", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("PAKISTAN HARDWARE - VAHOWA", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("BUILD WITH\nTHE BEST TOOLS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.1)),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => showContactDialog("WhatsApp Order", "Order karne k liye contact karein:\nWhatsApp: +$waNumber", "WA"),
                        icon: const Icon(Icons.chat, size: 14, color: Colors.white),
                        label: const Text("ORDER ON WHATSAPP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                    ],
                  ),
                ),

                // 3. Trust Badges
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("✔ 100% Original", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                      Text("⚡ Fast Delivery", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                      Text("🛡 Trusted", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Shop By Brand
                _buildHeader("SHOP BY BRAND"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _brandBtn("INGCO", const Color(0xFFC91414), "215 items"),
                      const SizedBox(width: 8),
                      _brandBtn("WADFOW", const Color(0xFFF39200), "125 items"),
                      const SizedBox(width: 8),
                      _brandBtn("TOTAL", const Color(0xFF00758F), "135 items"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 5. New Arrivals Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeader("NEW ARRIVALS"),
                      TextButton(
                        onPressed: () => filterBrand("ALL"),
                        child: const Text("See All ›", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                ),

                // 6. Products Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: displayProducts.length,
                  itemBuilder: (context, idx) {
                    final item = displayProducts[idx];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                              child: Image.network(
                                item.imgUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.build, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.brand, style: const TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
                                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("Rs. ${item.price}", style: const TextStyle(color: Color(0xFF00758F), fontWeight: FontWeight.w900, fontSize: 12)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  height: 28,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () => showContactDialog(
                                      "Order Now",
                                      "Tool: ${item.title}\nPrice: Rs. ${item.price}\n\nOrder WhatsApp par karein:\n+$waNumber",
                                      "ORDER",
                                    ),
                                    child: const Text("Order Now", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // 7. Visit Shop Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("VISIT OUR SHOP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => showContactDialog("Shop Location", shopAddress, "LOC"),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(shopAddress, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => showContactDialog("Call Us", "Phone: $shopPhone", "CALL"),
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text(shopPhone, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                          label: const Text("WHATSAPP PE ORDER KAREIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          onPressed: () => showContactDialog("WhatsApp Order", "Direct WhatsApp number:\n+$waNumber", "WA"),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),

          // Floating WhatsApp Action Button
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF25D366),
              onPressed: () => showContactDialog("WhatsApp Order", "Contact number:\n+$waNumber", "WA"),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: Colors.red),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _brandBtn(String brand, Color color, String count) {
    return Expanded(
      child: GestureDetector(
        onTap: () => filterBrand(brand),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(brand, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(count, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text("BROWSE →", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const PakistanToolsApp());
}

class PakistanToolsApp extends StatelessWidget {
  const PakistanToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}

class ToolItem {
  final String title;
  final String brand;
  final int price;
  final String imgUrl;

  ToolItem({
    required this.title,
    required this.brand,
    required this.price,
    required this.imgUrl,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String shopPhone = "+923451333385";
  final String waNumber = "923451333385";
  final String shopAddress = "College Road, Pakistan Tools, Vahowa";

  final List<ToolItem> allProducts = [
    ToolItem(
      title: "TOTAL 20V Cordless Lithium-Ion Drill (TDLI20024)",
      brand: "TOTAL",
      price: 14500,
      imgUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500",
    ),
    ToolItem(
      title: "INGCO 750W Angle Grinder 115mm (AG750282)",
      brand: "INGCO",
      price: 7800,
      imgUrl: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500",
    ),
    ToolItem(
      title: "WADFOW Claw Hammer 450g Heavy Duty",
      brand: "WADFOW",
      price: 1350,
      imgUrl: "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500",
    ),
    ToolItem(
      title: "TOTAL Rotary Hammer SDS Plus 800W",
      brand: "TOTAL",
      price: 19500,
      imgUrl: "https://images.unsplash.com/photo-1581244277943-fe4a9c777189?w=500",
    ),
    ToolItem(
      title: "INGCO Brushless Impact Driver 20V",
      brand: "INGCO",
      price: 21500,
      imgUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500",
    ),
    ToolItem(
      title: "WADFOW Precision Screwdriver Set 24 Pcs",
      brand: "WADFOW",
      price: 2200,
      imgUrl: "https://images.unsplash.com/photo-1586864387967-d02ef85d93e8?w=500",
    ),
  ];

  List<ToolItem> displayProducts = [];
  List<ToolItem> searchResults = [];
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayProducts = List.from(allProducts);
  }

  void showContactDialog(String title, String detail, String actionType) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(detail, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void filterBrand(String brand) {
    setState(() {
      if (brand == "ALL") {
        displayProducts = List.from(allProducts);
      } else {
        displayProducts = allProducts.where((p) => p.brand.toUpperCase() == brand.toUpperCase()).toList();
      }
    });
  }

  void onSearch(String text) {
    final q = text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        searchResults = [];
      } else {
        searchResults = allProducts
            .where((p) => p.title.toLowerCase().contains(q) || p.brand.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE41E26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("PT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("PAKISTAN TOOLS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                Text("Premium Hardware - Vahowa", style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: () => showContactDialog("Call Us", "Phone: $shopPhone", "CALL"),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            onChanged: onSearch,
                            decoration: const InputDecoration(
                              hintText: "Search tools, brands, items...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (searchCtrl.text.isNotEmpty) {
                              setState(() {
                                displayProducts = List.from(searchResults);
                                searchResults = [];
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text("GO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        )
                      ],
                    ),
                  ),
                ),

                // Search Suggestions Dropdown
                if (searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: Column(
                      children: searchResults.map((item) => ListTile(
                        dense: true,
                        title: Text(item.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        subtitle: Text("Rs. ${item.price} (${item.brand})", style: const TextStyle(color: Colors.blue, fontSize: 11)),
                        onTap: () {
                          searchCtrl.text = item.title;
                          setState(() {
                            displayProducts = [item];
                            searchResults = [];
                          });
                        },
                      )).toList(),
                    ),
                  ),

                // 2. Hero Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(16),
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B1B1B), Color(0xFFC91414)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                          child: const Text("500+ PRODUCTS", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("PAKISTAN HARDWARE - VAHOWA", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("BUILD WITH\nTHE BEST TOOLS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.1)),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => showContactDialog("WhatsApp Order", "Order karne k liye contact karein:\nWhatsApp: +$waNumber", "WA"),
                        icon: const Icon(Icons.chat, size: 14, color: Colors.white),
                        label: const Text("ORDER ON WHATSAPP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                    ],
                  ),
                ),

                // 3. Trust Badges
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text("✔ 100% Original", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                      Text("⚡ Fast Delivery", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                      Text("🛡 Trusted", style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 4. Shop By Brand
                _buildHeader("SHOP BY BRAND"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _brandBtn("INGCO", const Color(0xFFC91414), "215 items"),
                      const SizedBox(width: 8),
                      _brandBtn("WADFOW", const Color(0xFFF39200), "125 items"),
                      const SizedBox(width: 8),
                      _brandBtn("TOTAL", const Color(0xFF00758F), "135 items"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 5. New Arrivals Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeader("NEW ARRIVALS"),
                      TextButton(
                        onPressed: () => filterBrand("ALL"),
                        child: const Text("See All ›", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                ),

                // 6. Products Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: displayProducts.length,
                  itemBuilder: (context, idx) {
                    final item = displayProducts[idx];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                              child: Image.network(
                                item.imgUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.build, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.brand, style: const TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
                                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text("Rs. ${item.price}", style: const TextStyle(color: Color(0xFF00758F), fontWeight: FontWeight.w900, fontSize: 12)),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  height: 28,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () => showContactDialog(
                                      "Order Now",
                                      "Tool: ${item.title}\nPrice: Rs. ${item.price}\n\nOrder WhatsApp par karein:\n+$waNumber",
                                      "ORDER",
                                    ),
                                    child: const Text("Order Now", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // 7. Visit Shop Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("VISIT OUR SHOP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => showContactDialog("Shop Location", shopAddress, "LOC"),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(shopAddress, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => showContactDialog("Call Us", "Phone: $shopPhone", "CALL"),
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Text(shopPhone, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.chat, color: Colors.white, size: 16),
                          label: const Text("WHATSAPP PE ORDER KAREIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          onPressed: () => showContactDialog("WhatsApp Order", "Direct WhatsApp number:\n+$waNumber", "WA"),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 90),
              ],
            ),
          ),

          // Floating WhatsApp Action Button
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF25D366),
              onPressed: () => showContactDialog("WhatsApp Order", "Contact number:\n+$waNumber", "WA"),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      children: [
        Container(width: 4, height: 16, color: Colors.red),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _brandBtn(String brand, Color color, String count) {
    return Expanded(
      child: GestureDetector(
        onTap: () => filterBrand(brand),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(brand, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(count, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text("BROWSE →", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
    category: "Power Tools",
    price: 6850,
    icon: Icons.rotate_right_rounded,
    specs: "710W • 100mm (4\") Disc • 11000 RPM Copper Motor",
  ),
  const ToolProduct(
    id: "W2",
    title: "WADFOW Rotary Hammer 800W (WRH1D26)",
    brand: "WADFOW",
    category: "Power Tools",
    price: 13500,
    icon: Icons.hardware_rounded,
    specs: "800W • SDS Plus • 26mm Concrete Drilling Capacity",
  ),
  const ToolProduct(
    id: "W3",
    title: "WADFOW Cut Off Saw 2200W (WCF153551)",
    brand: "WADFOW",
    category: "Machinery",
    price: 24500,
    icon: Icons.carpenter_rounded,
    specs: "2200W • 355mm (14\") Blade • Heavy Duty Metal Cutting",
  ),
  const ToolProduct(
    id: "W4",
    title: "WADFOW Combination Pliers 8\" (WPL1718)",
    brand: "WADFOW",
    category: "Hand Tools",
    price: 1250,
    icon: Icons.handyman_rounded,
    specs: "Cr-V Steel • High Leverage 30% Energy Saving Grip",
  ),

  // --- INGCO PRODUCTS ---
  const ToolProduct(
    id: "I1",
    title: "INGCO 20V Brushless Drill (CDLI205582)",
    brand: "INGCO",
    category: "Cordless Tools",
    price: 15970,
    icon: Icons.bolt_rounded,
    specs: "20V Lithium-Ion • Brushless Motor • 55Nm Torque",
  ),
  const ToolProduct(
    id: "I2",
    title: "INGCO Impact Drill 710W (ID7118)",
    brand: "INGCO",
    category: "Power Tools",
    price: 9610,
    icon: Icons.offline_bolt_rounded,
    specs: "710W • 13mm Chuck • Hammer & Drill Variable Speed",
  ),
  const ToolProduct(
    id: "I3",
    title: "INGCO Angle Grinder 900W (AG90028)",
    brand: "INGCO",
    category: "Power Tools",
    price: 9940,
    icon: Icons.cached_rounded,
    specs: "900W • 125mm (5\") • Heavy Industrial Duty",
  ),
  const ToolProduct(
    id: "I4",
    title: "INGCO 166 Pcs Tool Set (HKTHP41662)",
    brand: "INGCO",
    category: "Hand Tools",
    price: 28500,
    icon: Icons.home_repair_service_rounded,
    specs: "166 Pcs Handtools + Cordless Drill Combo Kit",
  ),

  // --- TOTAL PRODUCTS ---
  const ToolProduct(
    id: "T1",
    title: "TOTAL 20V Cordless Impact Driver",
    brand: "TOTAL",
    category: "Cordless Tools",
    price: 17200,
    icon: Icons.electric_bolt_rounded,
    specs: "20V Brushless • 200Nm • 1/4\" Hex Drive",
  ),
  const ToolProduct(
    id: "T2",
    title: "TOTAL Inverter MMA Welding 200A",
    brand: "TOTAL",
    category: "Machinery",
    price: 26500,
    icon: Icons.flash_on_rounded,
    specs: "IGBT Inverter • Digital Display • 1.6-4.0mm Rods",
  ),
  const ToolProduct(
    id: "T3",
    title: "TOTAL Angle Grinder 850W (TG1081006)",
    brand: "TOTAL",
    category: "Power Tools",
    price: 8900,
    icon: Icons.change_circle_rounded,
    specs: "850W • 100mm (4\") • 11000 RPM Aluminium Box",
  ),
  const ToolProduct(
    id: "T4",
    title: "TOTAL Pressure Washer 1400W",
    brand: "TOTAL",
    category: "Power Tools",
    price: 21500,
    icon: Icons.water_damage_rounded,
    specs: "130 Bar Max Pressure • 5.5L/min Auto Stop System",
  ),
];

class PakistanToolsApp extends StatelessWidget {
  const PakistanToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainLayoutScreen(),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;
  static const String whatsappPhone = "923451333385";
  static const String shopAddress = "College Road, Pakistan Hardware, Vahowa";
  final TextEditingController _searchCtrl = TextEditingController();

  static void launchWhatsAppChat([String message = ""]) async {
    HapticFeedback.lightImpact();
    final defaultMsg = message.isNotEmpty
        ? message
        : "Assalam-o-Alaikum! Mujhe Pakistan Tools se order karna hai.";

    final directUri = Uri.parse("whatsapp://send?phone=$whatsappPhone&text=${Uri.encodeComponent(defaultMsg)}");
    final webUri = Uri.parse("https://wa.me/$whatsappPhone?text=${Uri.encodeComponent(defaultMsg)}");

    try {
      if (await canLaunchUrl(directUri)) {
        await launchUrl(directUri);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(webUri, mode: LaunchMode.platformDefault);
    }
  }

  void _launchCall() async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse("tel:+$whatsappPhone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openProductsPage({String? filterBrand, String? searchQuery}) {
    HapticFeedback.mediumImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsListScreen(
          filterBrand: filterBrand,
          searchQuery: searchQuery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        leadingWidth: 54,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "PT",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("PAKISTAN", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.5, height: 1.1)),
            Text("TOOLS", style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5, height: 1.0)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
            child: IconButton(icon: const Icon(Icons.call, color: Colors.black87, size: 20), onPressed: _launchCall),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.search, color: Colors.black54, size: 20),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _openProductsPage(searchQuery: value.trim());
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Search total, ingco, wadfow, tools...",
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                          minimumSize: const Size(40, 36),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          if (_searchCtrl.text.trim().isNotEmpty) {
                            _openProductsPage(searchQuery: _searchCtrl.text.trim());
                          }
                        },
                        child: const Text("GO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Hero Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFFB91C1C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "PAKISTAN HARDWARE • VAHOWA",
                          style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Text("${allTools.length}+", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD32F2F), fontSize: 12)),
                              const Text("PRODUCTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "BUILD WITH\nTHE BEST TOOLS",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, height: 1.15),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () => launchWhatsAppChat("Assalam-o-Alaikum! Mujhe Pakistan Tools se order karna hai."),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: const Text("ORDER ON WHATSAPP", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                    )
                  ],
                ),
              ),
            ),

            // Trust Badges
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _trustItem(Icons.check_circle_outline, "100% Original"),
                    _trustItem(Icons.local_shipping_outlined, "Fast Delivery"),
                    _trustItem(Icons.verified_user_outlined, "Trusted Store"),
                  ],
                ),
              ),
            ),

            // SHOP BY BRAND (Clickable to filter products)
            _sectionHeader("SHOP BY BRAND"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _brandCard("INGCO", "${allTools.where((t) => t.brand == 'INGCO').length} items", const Color(0xFFE53935), () {
                      _openProductsPage(filterBrand: "INGCO");
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _brandCard("WADFOW", "${allTools.where((t) => t.brand == 'WADFOW').length} items", const Color(0xFFF59E0B), () {
                      _openProductsPage(filterBrand: "WADFOW");
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _brandCard("TOTAL", "${allTools.where((t) => t.brand == 'TOTAL').length} items", const Color(0xFF0288D1), () {
                      _openProductsPage(filterBrand: "TOTAL");
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // CATEGORIES Section
            _sectionHeader("CATEGORIES"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _categoryChip("Power Tools", Icons.bolt, () => _openProductsPage(searchQuery: "Power Tools")),
                  const SizedBox(width: 8),
                  _categoryChip("Hand Tools", Icons.build, () => _openProductsPage(searchQuery: "Hand Tools")),
                  const SizedBox(width: 8),
                  _categoryChip("Cordless", Icons.battery_charging_full, () => _openProductsPage(searchQuery: "Cordless")),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // NEW ARRIVALS Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 18, color: const Color(0xFFD32F2F)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("NEW ARRIVALS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          Text("Freshly added products & rates", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _openProductsPage();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: const Text("See All ›", style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Products Carousel (Clean Branded Box - No Missing Images)
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: allTools.length,
                itemBuilder: (context, idx) {
                  final tool = allTools[idx];
                  return Container(
                    width: 175,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildToolImageHeader(tool, 105),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tool.brand, style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w900, fontSize: 10)),
                              const SizedBox(height: 2),
                              Text(tool.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, height: 1.15)),
                              const SizedBox(height: 4),
                              Text("Rs. ${tool.price}", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16A34A), fontSize: 13)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 28,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    elevation: 0,
                                  ),
                                  onPressed: () => launchWhatsAppChat("Assalam-o-Alaikum! Mujhe '${tool.title}' (Rs. ${tool.price}) order karna hai."),
                                  child: const Text("ORDER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // VISIT OUR SHOP (Footer)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("VISIT OUR SHOP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFD32F2F), size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(shopAddress, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.call, color: Color(0xFFD32F2F), size: 16),
                        const SizedBox(width: 8),
                        Text("+$whatsappPhone", style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => launchWhatsAppChat(),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text("WHATSAPP PE ORDER KAREIN", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => launchWhatsAppChat(),
        child: const Icon(Icons.chat_bubble_outline, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) _openProductsPage();
          if (i == 2) _openProductsPage();
          if (i == 3) _launchCall();
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Contact"),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFFD32F2F)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black87)),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: const Color(0xFFD32F2F)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _brandCard(String name, String count, Color accentColor, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(top: BorderSide(color: accentColor, width: 3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: accentColor, fontWeight: FontWeight.w900, fontSize: 12)),
            const SizedBox(height: 2),
            Text(count, style: const TextStyle(color: Colors.black45, fontSize: 9)),
            const SizedBox(height: 8),
            Row(
              children: const [
                Text("BROWSE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black87)),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 10, color: Colors.black87),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: const Color(0xFFD32F2F)),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildToolImageHeader(ToolProduct tool, double height) {
    Color brandColor = tool.brand == "INGCO"
        ? const Color(0xFFEF4444)
        : (tool.brand == "WADFOW" ? const Color(0xFFF59E0B) : const Color(0xFF0288D1));

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: brandColor.withOpacity(0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(tool.icon, size: 48, color: brandColor),
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: brandColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                tool.brand,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// DEDICATED PRODUCTS & BRAND DETAILS SCREEN
// ==========================================
class ProductsListScreen extends StatelessWidget {
  final String? filterBrand;
  final String? searchQuery;

  const ProductsListScreen({
    super.key,
    this.filterBrand,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    List<ToolProduct> filtered = allTools;

    if (filterBrand != null && filterBrand!.isNotEmpty) {
      filtered = filtered.where((p) => p.brand.toLowerCase() == filterBrand!.toLowerCase()).toList();
    }

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final q = searchQuery!.toLowerCase();
      filtered = filtered.where((p) =>
          p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.specs.toLowerCase().contains(q)).toList();
    }

    String screenTitle = "All Products";
    if (filterBrand != null) screenTitle = "$filterBrand Tools";
    if (searchQuery != null) screenTitle = "Results: $searchQuery";

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        title: Text(screenTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
      ),
      body: filtered.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_off, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Koi product nahi mila!", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final tool = filtered[idx];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MainLayoutScreenState._buildToolImageHeader(tool, 110),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tool.brand, style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w900, fontSize: 10)),
                              Text(tool.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(tool.specs, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                              const Spacer(),
                              Text("Rs. ${tool.price}", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF16A34A), fontSize: 13)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 28,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () => _MainLayoutScreenState.launchWhatsAppChat(
                                    "Assalam-o-Alaikum! Mujhe yeh tool order karna hai:\n\n"
                                    "🔧 *${tool.title}*\n"
                                    "🏷 Brand: ${tool.brand}\n"
                                    "💵 Price: Rs. ${tool.price}\n"
                                    "📋 Specs: ${tool.specs}",
                                  ),
                                  icon: const Icon(Icons.chat_bubble_outline, size: 12),
                                  label: const Text("ORDER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
    price: 6850,
    imageUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500&auto=format&fit=crop",
    specs: "710W • 100mm (4\") Disc • 11000 RPM Copper Motor",
  ),
  const ToolProduct(
    id: "W2",
    title: "WADFOW Rotary Hammer 800W (WRH1D26)",
    brand: "WADFOW",
    category: "Power Tools",
    price: 13500,
    imageUrl: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500&auto=format&fit=crop",
    specs: "800W • SDS Plus • 26mm Concrete Drilling Capacity",
  ),
  const ToolProduct(
    id: "W3",
    title: "WADFOW Cut Off Saw 2200W (WCF153551)",
    brand: "WADFOW",
    category: "Machinery",
    price: 24500,
    imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop",
    specs: "2200W • 355mm (14\") Blade • Heavy Duty Metal Cutting",
  ),
  const ToolProduct(
    id: "W4",
    title: "WADFOW Combination Pliers 8\" (WPL1718)",
    brand: "WADFOW",
    category: "Hand Tools",
    price: 1250,
    imageUrl: "https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=500&auto=format&fit=crop",
    specs: "Cr-V Steel • High Leverage 30% Energy Saving Grip",
  ),

  // INGCO
  const ToolProduct(
    id: "I1",
    title: "INGCO 20V Cordless Brushless Drill (CDLI205582)",
    brand: "INGCO",
    category: "Cordless Tools",
    price: 15970,
    imageUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500&auto=format&fit=crop",
    specs: "20V Lithium-Ion • Brushless Motor • 55Nm Torque",
  ),
  const ToolProduct(
    id: "I2",
    title: "INGCO Impact Drill 710W (ID7118)",
    brand: "INGCO",
    category: "Power Tools",
    price: 9610,
    imageUrl: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500&auto=format&fit=crop",
    specs: "710W • 13mm Chuck • Hammer & Drill Variable Speed",
  ),
  const ToolProduct(
    id: "I3",
    title: "INGCO Angle Grinder 900W (AG90028)",
    brand: "INGCO",
    category: "Power Tools",
    price: 9940,
    imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop",
    specs: "900W • 125mm (5\") • Heavy Industrial Duty",
  ),
  const ToolProduct(
    id: "I4",
    title: "INGCO 166 Pcs Tool Set with Box (HKTHP41662)",
    brand: "INGCO",
    category: "Hand Tools",
    price: 28500,
    imageUrl: "https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=500&auto=format&fit=crop",
    specs: "166 Pcs Handtools + Cordless Drill Combo Kit",
  ),

  // TOTAL
  const ToolProduct(
    id: "T1",
    title: "TOTAL 20V Cordless Impact Driver (TIRLI2001)",
    brand: "TOTAL",
    category: "Cordless Tools",
    price: 17200,
    imageUrl: "https://images.unsplash.com/photo-1504148455328-c376907d081c?w=500&auto=format&fit=crop",
    specs: "20V Brushless • 200Nm • 1/4\" Hex Drive",
  ),
  const ToolProduct(
    id: "T2",
    title: "TOTAL Inverter MMA Welding Machine 200A",
    brand: "TOTAL",
    category: "Machinery",
    price: 26500,
    imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop",
    specs: "IGBT Inverter • Digital Display • Electrodes 1.6-4.0mm",
  ),
  const ToolProduct(
    id: "T3",
    title: "TOTAL Angle Grinder 850W (TG1081006)",
    brand: "TOTAL",
    category: "Power Tools",
    price: 8900,
    imageUrl: "https://images.unsplash.com/photo-1572981779307-38b8cabb2407?w=500&auto=format&fit=crop",
    specs: "850W • 100mm (4\") • 11000 RPM Aluminium Gear Box",
  ),
  const ToolProduct(
    id: "T4",
    title: "TOTAL High Pressure Washer 1400W",
    brand: "TOTAL",
    category: "Power Tools",
    price: 21500,
    imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop",
    specs: "130 Bar Max Pressure • 5.5L/min Auto Stop System",
  ),
];

class PakistanToolsApp extends StatelessWidget {
  const PakistanToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Tools',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainLayoutScreen(),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;
  final String whatsappPhone = "923451333385";
  final String shopAddress = "College Road, Pakistan Hardware, Vahowa";
  final TextEditingController _searchCtrl = TextEditingController();

  final List<ToolProduct> _currentTools = List.from(fallbackTools);
  bool _isLoadingOnline = false;

  // Online prices integration is temporarily disabled. Use Tareeqa 2 if needed.
  // We will enable this again with correct configuration later.

  @override
  void initState() {
    super.initState();
    // Disabled fetching online prices for now to allow immediate fix.
    // _fetchLiveOnlinePrices();
  }

  // Future<void> _fetchLiveOnlinePrices() async { ... } // Temporarily commented out

  void _launchWhatsApp([String message = ""]) async {
    final defaultMsg = message.isNotEmpty
        ? message
        : "Assalam-o-Alaikum! Mujhe Pakistan Tools se order karna hai.";
    final uri = Uri.parse("https://wa.me/$whatsappPhone?text=${Uri.encodeComponent(defaultMsg)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchCall() async {
    final uri = Uri.parse("tel:+$whatsappPhone");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openProductsPage({String? filterBrand, String? searchQuery}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsListScreen(
          tools: _currentTools,
          filterBrand: filterBrand,
          searchQuery: searchQuery,
          whatsappPhone: whatsappPhone,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        leadingWidth: 54,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "PT",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("PAKISTAN", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 0.5, height: 1.1)),
            Text("TOOLS", style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5, height: 1.0)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
            child: IconButton(icon: const Icon(Icons.call, color: Colors.black87, size: 20), onPressed: _launchCall),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Functional Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.search, color: Colors.black54, size: 20),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _openProductsPage(searchQuery: value.trim());
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Search total, ingco, wadfow, tools...",
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                          minimumSize: const Size(40, 36),
                        ),
                        onPressed: () {
                          if (_searchCtrl.text.trim().isNotEmpty) {
                            _openProductsPage(searchQuery: _searchCtrl.text.trim());
                          }
                        },
                        child: const Text("GO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Hero Banner (Solid Dark Design - No white screen bug)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF111827), Color(0xFF1F2937), Color(0xFF991B1B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "PAKISTAN HARDWARE • VAHOWA",
                          style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Text("${_currentTools.length}+", style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFD32F2F), fontSize: 12)),
                              const Text("PRODUCTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 7, color: Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "BUILD WITH\nTHE BEST TOOLS",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, height: 1.15),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () => _launchWhatsApp("Assalam-o-Alaikum! Mujhe Pakistan Tools se order karna hai."),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: const Text("ORDER ON WHATSAPP", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                    )
                  ],
                ),
              ),
            ),

            // Trust Badges
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _trustItem(Icons.check_circle_outline, "100% Original"),
                    _trustItem(Icons.local_shipping_outlined, "Fast Delivery"),
                    _trustItem(Icons.verified_user_outlined, "Trusted"),
                  ],
                ),
              ),
            ),

            // SHOP BY BRAND (Clickable to show all brand tools)
            _sectionHeader("SHOP BY BRAND"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _brandCard("INGCO", "${_currentTools.where((t) => t.brand == 'INGCO').length} items", const Color(0xFFE53935), () {
                      _openProductsPage(filterBrand: "INGCO");
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _brandCard("WADFOW", "${_currentTools.where((t) => t.brand == 'WADFOW').length} items", const Color(0xFFF59E0B), () {
                      _openProductsPage(filterBrand: "WADFOW");
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _brandCard("TOTAL", "${_currentTools.where((t) => t.brand == 'TOTAL').length} items", const Color(0xFF0288D1), () {
                      _openProductsPage(filterBrand: "TOTAL");
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // CATEGORIES Section
            _sectionHeader("CATEGORIES"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _categoryChip("Power Tools", Icons.bolt, () => _openProductsPage(searchQuery: "Power Tools")),
                  const SizedBox(width: 8),
                  _categoryChip("Hand Tools", Icons.build, () => _openProductsPage(searchQuery: "Hand Tools")),
                  const SizedBox(width: 8),
                  _categoryChip("Cordless", Icons.battery_charging_full, () => _openProductsPage(searchQuery: "Cordless")),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // NEW ARRIVALS Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 18, color: const Color(0xFFD32F2F)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("NEW ARRIVALS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          Text("Real Tools & Prices", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _openProductsPage(),
                    child: const Text("See All ›", style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Real Products Horizontal Carousel
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _currentTools.take(6).length,
                itemBuilder: (context, idx) {
                  final tool = _currentTools[idx];
                  return Container(
                    width: 170,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            tool.imageUrl,
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 110, color: Colors.grey.shade200, child: const Icon(Icons.hardware)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tool.brand, style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w900, fontSize: 10)),
                              Text(tool.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, height: 1.1)),
                              const SizedBox(height: 4),
                              Text("Rs. ${tool.price}", style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 13)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 26,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () => _launchWhatsApp("Assalam-o-Alaikum! Mujhe '${tool.title}' order karna hai."),
                                  child: const Text("ORDER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // VISIT OUR SHOP (Dark Box)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("VISIT OUR SHOP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFD32F2F), size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(shopAddress, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.call, color: Color(0xFFD32F2F), size: 16),
                        const SizedBox(width: 8),
                        Text("+$whatsappPhone", style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => _launchWhatsApp(),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text("WHATSAPP PE ORDER KAREIN", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => _launchWhatsApp(),
        child: const Icon(Icons.chat_bubble_outline, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 1) _openProductsPage();
          if (i == 3) _launchCall();
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Contact"),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFFD32F2F)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black87)),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: const Color(0xFFD32F2F)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _brandCard(String name, String count, Color accentColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(top: BorderSide(color: accentColor, width: 3)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: accentColor, fontWeight: FontWeight.w900, fontSize: 12)),
            const SizedBox(height: 2),
            Text(count, style: const TextStyle(color: Colors.black45, fontSize: 9)),
            const SizedBox(height: 8),
            Row(
              children: const [
                Text("BROWSE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black87)),
                SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 10, color: Colors.black87),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: const Color(0xFFD32F2F)),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// DEDICATED PRODUCTS & BRAND DETAILS SCREEN
// ==========================================
class ProductsListScreen extends StatelessWidget {
  final List<ToolProduct> tools;
  final String? filterBrand;
  final String? searchQuery;
  final String whatsappPhone;

  const ProductsListScreen({
    super.key,
    required this.tools,
    this.filterBrand,
    this.searchQuery,
    required this.whatsappPhone,
  });

  void _orderWhatsApp(ToolProduct tool) async {
    final msg = "Assalam-o-Alaikum! Mujhe yeh tool order karna hai:\n\n"
        "🔧 *${tool.title}*\n"
        "🏷 Brand: ${tool.brand}\n"
        "💵 Price: Rs. ${tool.price}\n"
        "📋 Specs: ${tool.specs}";
    final uri = Uri.parse("https://wa.me/$whatsappPhone?text=${Uri.encodeComponent(msg)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ToolProduct> filtered = tools;

    if (filterBrand != null && filterBrand!.isNotEmpty) {
      filtered = filtered.where((p) => p.brand.toLowerCase() == filterBrand!.toLowerCase()).toList();
    }

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final q = searchQuery!.toLowerCase();
      filtered = filtered.where((p) =>
          p.title.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.specs.toLowerCase().contains(q)).toList();
    }

    String screenTitle = "All Products";
    if (filterBrand != null) screenTitle = "$filterBrand Tools";
    if (searchQuery != null) screenTitle = "Results: $searchQuery";

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 0.5,
      ),
      body: filtered.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search_off, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Koi product nahi mila!", style: TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final tool = filtered[idx];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          tool.imageUrl,
                          height: 115,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(height: 115, color: Colors.grey.shade200, child: const Icon(Icons.hardware)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tool.brand, style: const TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.w900, fontSize: 10)),
                              Text(tool.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                              const SizedBox(height: 2),
                              Text(tool.specs, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                              const Spacer(),
                              Text("Rs. ${tool.price}", style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 13)),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 28,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () => _orderWhatsApp(tool),
                                  icon: const Icon(Icons.chat_bubble_outline, size: 12),
                                  label: const Text("ORDER", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
