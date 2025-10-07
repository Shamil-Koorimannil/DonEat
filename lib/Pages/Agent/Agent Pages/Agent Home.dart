import 'package:doneat/Pages/Agent/Agent%20Pages/Agent%20Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Models/DonEat_model.dart';
import '../../Donor/Donor Pages/ChatScreen.dart';
import '../../Agent/Agent Widgets/bottom_nav.dart';
import '../Agent Widgets/header.dart';
import 'Delivery page.dart';
import 'Donation Details.dart';

class AgentHome extends StatefulWidget {
  const AgentHome({super.key});

  @override
  State<AgentHome> createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome>
    with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  bool _isOnline = false;
  late TabController _tabController;

  List<Donation> pendingDonations = [];
  List<Donation> completedDonations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDonations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadDonations() {
    final donationsBox = Hive.box<Donation>('donations');
    final sessionBox = Hive.box('session');
    String? currentAgentId = sessionBox.get('agentId');

    setState(() {
      if (currentAgentId != null) {
        pendingDonations = donationsBox.values
            .where((donation) => donation.status == "accepted" && donation.acceptedByAgentId == currentAgentId)
            .toList();

        completedDonations = donationsBox.values
            .where((donation) => donation.status == "completed" && donation.acceptedByAgentId == currentAgentId)
            .toList();
      } else {
        pendingDonations = donationsBox.values
            .where((donation) => donation.status == "accepted")
            .toList();
        completedDonations = donationsBox.values
            .where((donation) => donation.status == "completed")
            .toList();
      }
    });
  }

  void _refreshDonations() {
    _loadDonations();
  }

  void _onTabTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  Widget _agent_home() {
    final Color activeColor = const Color(0xFFFF863B);
    final Color inactiveColor = Colors.grey.shade700;

    return SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: AgentHead(),
            child: Container(
              color: const Color(0xFFFF863B),
              height: 180,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: const [
                    SizedBox(height: 20),
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Earnings", "0"),
                _divider(),
                _buildStatItem("Online Time", "00:00"),
                _divider(),
                _buildStatItem("Pickups", "${completedDonations.length}"),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              labelColor: activeColor,
              unselectedLabelColor: inactiveColor,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 3,
                  color: activeColor,
                ),
                insets: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              tabs: const [
                Tab(text: "Pending"),
                Tab(text: "Completed"),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                pendingDonations.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pending_actions, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "No pending deliveries",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        "Accept deliveries from Delivery tab",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingDonations.length,
                  itemBuilder: (context, index) {
                    final donation = pendingDonations[index];
                    return _buildPendingCard(donation, index);
                  },
                ),
                completedDonations.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "No completed deliveries",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        "Complete deliveries from Pending tab",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: completedDonations.length,
                  itemBuilder: (context, index) {
                    final donation = completedDonations[index];
                    return _buildCompletedCard(donation, index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingCard(Donation donation, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgentDonationDetails(
              donation: donation,
              onStatusChanged: _refreshDonations,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation.foodName ?? 'No Food Name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${donation.quantity} people • ${donation.location ?? 'No Location'}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${donation.date ?? 'No Date'} ${donation.time ?? 'No Time'}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chat, color: Colors.blue, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(donation: donation),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedCard(Donation donation, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donation.foodName ?? 'No Food Name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${donation.quantity} people • ${donation.location ?? 'No Location'}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed • ${donation.date ?? 'No Date'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.chat, color: Colors.grey, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(donation: donation),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Completed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _agent_home(),
      DeliveryPage(),
      const AgentProfile()
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_pageIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _pageIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 35,
      color: Colors.grey.shade300,
    );
  }
}