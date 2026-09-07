import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PakistanToolsApp());
}

// Product Model
class ToolProduct {
  final String id;
  final String title;
  final String brand; // INGCO, WADFOW, TOTAL
  final String category;
  final int price;
  final String imageUrl;
  final String specs;

  const ToolProduct({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.specs,
  });

  factory ToolProduct.fromJson(Map<String, dynamic> json) {
    return ToolProduct(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Tool Item',
      brand: json['brand']?.toString() ?? 'General',
      category: json['category']?.toString() ?? 'Tools',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      specs: json['specs']?.toString() ?? '',
    );
  }
}

// Fallback products agar internet na ho
final List<ToolProduct> fallbackTools = [
  // WADFOW
  const ToolProduct(
    id: "W1",
    title: "WADFOW Angle Grinder 710W (WAG35762)",
    brand: "WADFOW",
    category: "Power Tools",
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

  List<ToolProduct> _currentTools = List.from(fallbackTools);
  bool _isLoadingOnline = false;

  // Live Online Price & Product Update Endpoint
  final String _onlinePricesUrl =
      "https://raw.githubusercontent.com/adilsultanshah786-svg/pakistan-hardware/main/products.json";

  @override
  void initState() {
    super.initState();
    _fetchLiveOnlinePrices();
  }

  Future<void> _fetchLiveOnlinePrices() async {
    setState(() => _isLoadingOnline = true);
    try {
      final response = await http.get(Uri.parse(_onlinePricesUrl)).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ToolProduct> loaded = data.map((item) => ToolProduct.fromJson(item)).toList();
        if (loaded.isNotEmpty) {
          setState(() {
            _currentTools = loaded;
          });
        }
      }
    } catch (_) {
      // Agar internet na ho ya file na milay to fallback tools pe chalay ga
    } finally {
      if (mounted) setState(() => _isLoadingOnline = false);
    }
  }

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
          IconButton(
            icon: _isLoadingOnline
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFD32F2F)))
                : const Icon(Icons.sync, color: Colors.black87, size: 20),
            onPressed: _fetchLiveOnlinePrices,
            tooltip: "Update Live Prices",
          ),
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
            child: IconButton(icon: const Icon(Icons.call, color: Colors.black87, size: 20), onPressed: _launchCall),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLiveOnlinePrices,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      _trustItem(Icons.verified_user_outlined, "Live Prices Sync"),
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
                            Text("Auto updated products & rates", style: TextStyle(color: Colors.grey, fontSize: 10)),
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
