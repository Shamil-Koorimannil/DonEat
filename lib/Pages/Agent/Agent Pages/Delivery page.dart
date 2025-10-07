import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Models/DonEat_model.dart';
import '../Agent Widgets/header.dart';
import 'Donation Details.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  List<Donation> availableDonations = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableDonations();
  }

  void _loadAvailableDonations() {
    final donationsBox = Hive.box<Donation>('donations');
    setState(() {
      availableDonations = donationsBox.values
          .where((donation) => donation.status == "available")
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                      'Deliveries',
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
          const SizedBox(height: 20),
          Expanded(
            child: availableDonations.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fastfood, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No available deliveries",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: availableDonations.length,
              itemBuilder: (context, index) {
                final donation = availableDonations[index];
                return _buildDonationCard(donation, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard(Donation donation, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgentDonationDetails(
              donation: donation,
              onStatusChanged: _loadAvailableDonations,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF863B),
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
                    'Food: ${donation.foodName ?? 'No Food Name'}',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity: ${donation.quantity} people',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${donation.location ?? 'No Location'}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: ${donation.date ?? 'No Date'} ${donation.time ?? 'No Time'}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contact: ${donation.contact ?? 'No Contact'}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}