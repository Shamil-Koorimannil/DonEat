import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Concense/keys_consence.dart';
import '../../../Models/DonEat_model.dart';
import '../../Donor/Donor Pages/ChatScreen.dart';
import 'Donation Details.dart';

class AgentPendingPage extends StatefulWidget {
  const AgentPendingPage({super.key});

  @override
  State<AgentPendingPage> createState() => _AgentPendingPageState();
}

class _AgentPendingPageState extends State<AgentPendingPage> {
  List<Donation> pendingDonations = [];

  @override
  void initState() {
    super.initState();
    _loadPendingDonations();
  }

  void _loadPendingDonations() {
    final donationsBox = Hive.box<Donation>(KeysConstant.donationsBox);
    final sessionBox = Hive.box(KeysConstant.sessionBox);
    String? currentAgentId = sessionBox.get(KeysConstant.agentId);

    setState(() {
      if (currentAgentId != null) {
        pendingDonations = donationsBox.values
            .where((donation) =>
        donation.status == KeysConstant.acceptedStatus &&
            donation.acceptedByAgentId == currentAgentId)
            .toList();
      } else {
        pendingDonations = donationsBox.values
            .where((donation) => donation.status == KeysConstant.acceptedStatus)
            .toList();
      }
    });
  }

  void _refreshDonations() {
    _loadPendingDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFFFF863B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
            child: const SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Pending Deliveries',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your accepted deliveries',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _refreshDonations,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF863B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  label: const Text(
                    "Refresh",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: pendingDonations.isEmpty
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
                    "Accept deliveries from the Available tab",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: pendingDonations.length,
              itemBuilder: (context, index) {
                final donation = pendingDonations[index];
                return _buildPendingDonationCard(donation, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingDonationCard(Donation donation, int index) {
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food: ${donation.foodName}',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity: ${donation.quantity} people',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${donation.location}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${donation.date} ${donation.time}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.chat, color: Colors.blue),
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
          ],
        ),
      ),
    );
  }
}