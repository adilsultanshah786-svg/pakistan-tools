import 'package:flutter/material.dart';
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
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      home: const ToolsHomeScreen(),
    );
  }
}

class ToolProduct {
  final String title;
  final String price;
  final String brand;
  final String modelNumber;
  final IconData icon;

  ToolProduct({
    required this.title,
    required this.price,
    required this.brand,
    required this.modelNumber,
    required this.icon,
  });
}

class ToolsHomeScreen extends StatefulWidget {
  const ToolsHomeScreen({super.key});

  @override
  State<ToolsHomeScreen> createState() => _ToolsHomeScreenState();
}

class _ToolsHomeScreenState extends State<ToolsHomeScreen> {
  final String storeName = "Pakistan Tools";
  final String whatsappPhone = "923451333385";
  final String shopAddress = "Pakistan tools College road vahowa";

  String activeBrand = "All";
  String searchKeyword = "";
  final TextEditingController _searchCtrl = TextEditingController();

  final Map<String, Color> brandColors = {
    "Total": const Color(0xFF00828A),
    "Ingco": const Color(0xFFF37021),
    "Wadfow": const Color(0xFF0C2340),
  };

  final List<ToolProduct> inventory = [
    ToolProduct(
      title: "INGCO Lithium-Ion Cordless Drill 20V",
      price: "Rs. 13,800",
      brand: "Ingco",
      modelNumber: "CDLI20024",
      icon: Icons.handyman,
    ),
    ToolProduct(
      title: "TOTAL 1010W Heavy Duty Angle Grinder",
      price: "Rs. 8,450",
      brand: "Total",
      modelNumber: "TG1121156",
      icon: Icons.settings,
    ),
    ToolProduct(
      title: "WADFOW 46 Pcs 1/4\" Socket Mechanics Set",
      price: "Rs. 3,650",
      brand: "Wadfow",
      modelNumber: "WSS1K46",
      icon: Icons.hardware,
    ),
    ToolProduct(
      title: "TOTAL Industrial Cordless Rotary Hammer 20V",
      price: "Rs. 24,500",
      brand: "Total",
      modelNumber: "TRHLI20228",
      icon: Icons.precision_manufacturing,
    ),
    ToolProduct(
      title: "INGCO 2200W High Pressure Car Washer 150Bar",
      price: "Rs. 29,999",
      brand: "Ingco",
      modelNumber: "HPWR22008",
      icon: Icons.local_car_wash,
    ),
    ToolProduct(
      title: "WADFOW 300W Mini Electric Rotary Die Grinder",
      price: "Rs. 4,950",
      brand: "Wadfow",
      modelNumber: "WRG1501",
      icon: Icons.construction,
    ),
  ];

  void _openWhatsApp(ToolProduct item) async {
    final text = Uri.encodeComponent(
      "Assalam-o-Alaikum!\n\n"
      "Mujhe *$storeName* se yeh tool order karna hai:\n"
      "• *Item:* ${item.title}\n"
      "• *Brand:* ${item.brand}\n"
      "• *Model:* ${item.modelNumber}\n"
      "• *Price:* ${item.price}\n\n"
      "Address: $shopAddress\n"
      "Kindly confirmation aur delivery details share karein."
    );
    final link = Uri.parse("https://wa.me/$whatsappPhone?text=$text");
    if (await canLaunchUrl(link)) {
      await launchUrl(link, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = inventory.where((item) {
      final brandMatch = (activeBrand == "All" || item.brand.toLowerCase() == activeBrand.toLowerCase());
      final searchMatch = item.title.toLowerCase().contains(searchKeyword.toLowerCase()) ||
                          item.modelNumber.toLowerCase().contains(searchKeyword.toLowerCase());
      return brandMatch && searchMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(storeName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white)),
            Text(shopAddress, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined, color: Colors.amber, size: 26),
            onPressed: () => _showStoreDialog(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(62),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => searchKeyword = v),
                decoration: InputDecoration(
                  hintText: "Search tool, drill, model number...",
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: searchKeyword.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => searchKeyword = "");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  _buildBrandButton("All", const Color(0xFF0F172A)),
                  const SizedBox(width: 8),
                  _buildBrandButton("Total", brandColors["Total"]!),
                  const SizedBox(width: 8),
                  _buildBrandButton("Ingco", brandColors["Ingco"]!),
                  const SizedBox(width: 8),
                  _buildBrandButton("Wadfow", brandColors["Wadfow"]!),
                ],
              ),
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text("Koi tool nahi mila!"))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (ctx, idx) {
                      final item = filteredList[idx];
                      final primaryColor = brandColors[item.brand] ?? Colors.black;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              color: primaryColor.withOpacity(0.06),
                              child: Icon(item.icon, size: 48, color: primaryColor),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.brand.toUpperCase(),
                                    style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    item.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.price,
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: primaryColor),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF25D366),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                      ),
                                      onPressed: () => _openWhatsApp(item),
                                      icon: const Icon(Icons.chat, size: 14),
                                      label: const Text("Order Now", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
        ],
      ),
    );
  }

  Widget _buildBrandButton(String title, Color brandColor) {
    final bool isSelected = (activeBrand == title);
    return InkWell(
      onTap: () => setState(() => activeBrand = title),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? brandColor : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title == "All" ? "All Tools" : title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  void _showStoreDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(storeName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(shopAddress),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text("WhatsApp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text("+92 345 1333385"),
            ),
          ],
        ),
      ),
    );
  }
}
