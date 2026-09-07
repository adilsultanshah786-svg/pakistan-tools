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
        scaffoldBackgroundColor: const Color(0xFFF3F4F6), // Modern light grey
        fontFamily: 'Roboto',
        useMaterial3: true,
        // Upgraded professional color palette
        primaryColor: const Color(0xFFC62828), // Professional Deep Red
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC62828)),
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

  void _launchWhatsApp([String message = ""]) async {
    final defaultMsg = message.isNotEmpty 
        ? message 
        : "Assalam-o-Alaikum! Mujhe Pakistan Tools se maloomat leni hain.";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // Fixes white app bar issue in newer Flutter versions
        elevation: 0.5,
        leadingWidth: 54,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFC62828), // Deep Red Logo
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "PT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "PAKISTAN",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 0.5,
                height: 1.1,
              ),
            ),
            Text(
              "TOOLS",
              style: TextStyle(
                color: Color(0xFFC62828), // Deep Red
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 0.5,
                height: 1.0,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.phone_in_talk, color: Colors.black, size: 22),
              onPressed: _launchCall,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upgraded Search Bar with elevated look
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.search_rounded, color: Colors.grey, size: 22),
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search total, ingco, hand tools...",
                          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          minimumSize: const Size(44, 38),
                        ),
                        onPressed: () {},
                        child: const Text("GO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Hero Banner (more compact and impactful)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1598446270529-679e9a4f4d22?q=80&w=1470&auto=format&fit=crop"), // Realistic background image
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: const [
                            Text("100+", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFC62828), fontSize: 13)),
                            Text("PRODUCTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "PAKISTAN HARDWARE • VAHOWA",
                            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "BUILD WITH\nTHE BEST TOOLS",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, height: 1.1),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF37021),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onPressed: () => _launchWhatsApp("Assalam-o-Alaikum! Mujhe tool order karna hai."),
                            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                            label: const Text("ORDER ON WHATSAPP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            // More space-efficient and visual Categories section
            _sectionHeader("CATEGORIES"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryIconCard("Power Tools", Icons.electric_bolt, const Color(0xFFC62828)),
                    _categoryIconCard("Hand Tools", Icons.handyman, const Color(0xFFC62828)),
                    _categoryIconCard("Machinery", Icons.precision_manufacturing, const Color(0xFFC62828)),
                    _categoryIconCard("Safety Gear", Icons.health_and_safety, const Color(0xFFC62828)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Professional SHOP BY BRAND with deeper card design
            _sectionHeader("SHOP BY BRAND"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _brandCardUpgraded("INGCO", "18 items", const Color(0xFFC62828), Icons.hardware_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _brandCardUpgraded("WADFOW", "12 items", const Color(0xFFF37021), Icons.construction_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _brandCardUpgraded("TOTAL", "24 items", const Color(0xFF0288D1), Icons.settings_accessibility_rounded)),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Visually prominent NEW ARRIVALS section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 18, color: const Color(0xFFC62828)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("NEW ARRIVALS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                          Text("Freshly added products", style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      )
                    ],
                  ),
                  const Text("See All ›", style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Upgraded dark Box for VISIT OUR SHOP (more impactful)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937), // Deeper dark grey/blue
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "VISIT OUR SHOP",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 16),
                    _shopInfoRow(Icons.location_on_rounded, shopAddress),
                    const SizedBox(height: 10),
                    _shopInfoRow(Icons.phone_enabled_rounded, "+$whatsappPhone"),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => _launchWhatsApp(),
                        icon: const Icon(Icons.chat_rounded, size: 20),
                        label: const Text(
                          "WHATSAPP PE ORDER KAREIN",
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80), // Increased Bottom space for floating button
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 6,
        onPressed: () => _launchWhatsApp(),
        child: const Icon(Icons.chat_rounded, size: 28),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFC62828), // Deep Red
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.manage_search_rounded), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Categories"),
            BottomNavigationBarItem(icon: Icon(Icons.connect_without_contact_rounded), label: "Contact"),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: const Color(0xFFC62828)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _categoryIconCard(String label, IconData icon, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _brandCardUpgraded(String name, String count, Color accentColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(top: BorderSide(color: accentColor, width: 3.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(color: accentColor, fontWeight: FontWeight.w900, fontSize: 13)),
              Icon(icon, size: 14, color: accentColor),
            ],
          ),
          const SizedBox(height: 3),
          Text(count, style: const TextStyle(color: Colors.black54, fontSize: 10)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Text("BROWSE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black87)),
              SizedBox(width: 3),
              Icon(Icons.arrow_forward_ios_rounded, size: 8, color: Colors.black87),
            ],
          )
        ],
      ),
    );
  }

  Widget _shopInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFC62828), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 11.5, height: 1.4),
          ),
        ),
      ],
    );
  }
}
