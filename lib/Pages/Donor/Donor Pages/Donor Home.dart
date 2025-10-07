import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Models/DonEat_model.dart';
import '../Donor Widgets/bottom_nav.dart';
import '../Donor Widgets/header.dart';
import 'ChatScreen.dart';
import 'Detailed screen.dart';
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

  List<Donation> onlineDonations = [];
  List<Donation> previousDonations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    final box = Hive.box<Donation>('donations');
    final sessionBox = Hive.box('session');
    final donorsBox = Hive.box<Donor>('donors');

    int? currentDonorIndex = sessionBox.get('loggedInUserIndex');
    Donor? currentDonor;

    if (currentDonorIndex != null && currentDonorIndex < donorsBox.length) {
      currentDonor = donorsBox.getAt(currentDonorIndex);
    }

    final allDonations = box.values.toList();

    setState(() {
      if (currentDonor != null) {
        onlineDonations = allDonations.where((donation) =>
        (donation.status == "available" || donation.status == "accepted") &&
            donation.donorEmail == currentDonor!.email
        ).toList();

        previousDonations = allDonations.where((donation) =>
        donation.status == "completed" &&
            donation.donorEmail == currentDonor!.email
        ).toList();
      } else {
        onlineDonations = allDonations.where((donation) =>
        donation.status == "available" || donation.status == "accepted").toList();
        previousDonations = allDonations.where((donation) =>
        donation.status == "completed").toList();
      }
    });
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

  void addOnlineDonation(Donation donation) {
    setState(() {
      onlineDonations.add(donation);
    });

    _tabController.animateTo(0);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Donation added successfully!")),
    );
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
            children: [
              onlineDonations.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fastfood, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No active donations",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      "Click the donate button to add food",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadDonations,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: onlineDonations.length,
                  itemBuilder: (context, index) {
                    final donation = onlineDonations[index];
                    return _buildDonationCard(donation, index, true);
                  },
                ),
              ),
              previousDonations.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No previous donations",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadDonations,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: previousDonations.length,
                  itemBuilder: (context, index) {
                    final donation = previousDonations[index];
                    return _buildDonationCard(donation, index, false);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDonationCard(Donation donation, int index, bool isOnline) {
    return GestureDetector(
      onTap: () {
        _showDonationDetails(donation);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isOnline ? const Color(0xFFFF863B) : Colors.grey,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Food: ${donation.foodName ?? 'Not specified'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Quantity: ${donation.quantity ?? 0} people',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Location: ${donation.location ?? 'Not specified'}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Time: ${donation.date ?? ''} ${donation.time ?? ''}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    if (donation.status == "available")
                      const Text(
                        'Status: Waiting for Agent',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    if (donation.status == "accepted")
                      const Text(
                        'Status: Accepted by Agent',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    if (donation.status == "completed")
                      const Text(
                        'Status: Completed',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
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
                      icon: const Icon(Icons.arrow_forward_outlined, color: Color(0xFFFF863B), size: 20),
                      onPressed: () => _showDonationDetails(donation),
                    ),

                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelDonation(Donation donation, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Donation"),
        content: const Text("Are you sure you want to cancel this donation?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final donationsBox = Hive.box<Donation>('donations');

      final donationsList = donationsBox.values.toList();
      final donationIndex = donationsList.indexWhere((d) => d.donationId == donation.donationId);

      if (donationIndex != -1) {
        await donationsBox.deleteAt(donationIndex);
        await _deleteChatMessages(donation.donationId!);

        setState(() {
          onlineDonations.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Donation cancelled successfully")),
        );
      }
    }
  }

  Future<void> _deleteChatMessages(String donationId) async {
    final chatBox = Hive.box<ChatMessage>('chatMessages');
    final messagesToDelete = chatBox.values
        .where((message) => message.donationId == donationId)
        .toList();

    for (var message in messagesToDelete) {
      final messageIndex = chatBox.values.toList().indexOf(message);
      if (messageIndex != -1) {
        await chatBox.deleteAt(messageIndex);
      }
    }
  }

  void _showDonationDetails(Donation donation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(donation: donation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      DonatePageWrapper(onDonationAdded: addOnlineDonation),
      const DonorProfile(),
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
}

class DonatePageWrapper extends StatelessWidget {
  final Function(Donation) onDonationAdded;

  const DonatePageWrapper({super.key, required this.onDonationAdded});

  @override
  Widget build(BuildContext context) {
    return Donate(
      onDonationSaved: (donation) {
        onDonationAdded(donation);
      },
    );
  }
}