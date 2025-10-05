import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Donor Widgets/bottom_nav.dart';
import '../Donor Widgets/header.dart';
import 'Donor Donate page.dart';
import 'Donor_Profile.dart';

class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome>
    with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Widget _buildHomePage() {
    return Column(
      children: [
        ClipPath(
          clipper: DonorHead(),
          child: Container(
            color: const Color(0xFFFF863B),
            height: 200,
            width: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(CupertinoIcons.back, size: 30),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFFF863B),
            unselectedLabelColor: const Color(0xFF666666),
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: Color(0xFFFF863B),
              ),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            tabs: const [
              Tab(text: "Online"),
              Tab(text: "Previous"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text("👉 Online Orders")),
              Center(child: Text("📜 Previous Orders")),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      const Donate(),
      const DonorProfile(),
    ];

    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _pageIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
