import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Concense/keys_consence.dart';
import '../../../Models/DonEat_model.dart';
import '../../Donor/Donor Pages/ChatScreen.dart';
import '../Agent Widgets/header.dart';

class AgentDonationDetails extends StatefulWidget {
  final Donation donation;
  final VoidCallback onStatusChanged;

  const AgentDonationDetails({
    super.key,
    required this.donation,
    required this.onStatusChanged,
  });

  @override
  State<AgentDonationDetails> createState() => _AgentDonationDetailsState();
}

class _AgentDonationDetailsState extends State<AgentDonationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
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
                          'Details',
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
              Positioned(
                top: 35,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFFFF7C2A)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Food Name", widget.donation.foodName ?? 'Not provided'),
                      const SizedBox(height: 15),
                      _buildDetailRow("Pickup Location", widget.donation.location ?? 'Not provided'),
                      const SizedBox(height: 15),
                      _buildDetailRow("Pickup Date", widget.donation.date ?? 'Not provided'),
                      const SizedBox(height: 15),
                      _buildDetailRow("Pickup Time", widget.donation.time ?? 'Not provided'),
                      const SizedBox(height: 15),
                      _buildDetailRow("Contact", widget.donation.contact ?? 'Not provided'),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Quantity (People):",
                              style: TextStyle(fontSize: 14, color: Colors.black87)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7C2A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${widget.donation.quantity ?? 0}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Food Images:",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      if (widget.donation.imagePaths != null && widget.donation.imagePaths!.isNotEmpty)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.donation.imagePaths!.map((imagePath) {
                              return Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFFF7C2A)),
                                ),
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.image, color: Colors.grey),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      else
                        const Text("No images provided", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.donation.status ?? 'available'),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getStatusIcon(widget.donation.status ?? 'available'),
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Status: ${_getStatusText(widget.donation.status ?? 'available')}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      if ((widget.donation.status ?? 'available') == KeysConstant.availableStatus)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF863B),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _acceptDonation,
                                child: const Text(
                                  "Accept Delivery",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        )
                      else if ((widget.donation.status ?? 'available') == KeysConstant.acceptedStatus)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: _completeDelivery,
                                child: const Text(
                                  "Complete Delivery",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF7C2A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(donation: widget.donation),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Go to Chat",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else if ((widget.donation.status ?? 'available') == KeysConstant.completedStatus)
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delivery Completed Successfully",
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF7C2A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(donation: widget.donation),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View Chat History",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFF7C2A)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case KeysConstant.availableStatus:
        return Colors.orange;
      case KeysConstant.acceptedStatus:
        return Colors.blue;
      case KeysConstant.completedStatus:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case KeysConstant.availableStatus:
        return Icons.access_time;
      case KeysConstant.acceptedStatus:
        return Icons.check_circle;
      case KeysConstant.completedStatus:
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case KeysConstant.availableStatus:
        return "Waiting for Agent";
      case KeysConstant.acceptedStatus:
        return "Accepted by You";
      case KeysConstant.completedStatus:
        return "Completed";
      default:
        return "Unknown";
    }
  }

  void _acceptDonation() async {
    final donationsBox = Hive.box<Donation>(KeysConstant.donationsBox);
    final sessionBox = Hive.box(KeysConstant.sessionBox);

    String? currentAgentId = sessionBox.get(KeysConstant.agentId) ?? 'agent_${DateTime.now().millisecondsSinceEpoch}';

    widget.donation.status = KeysConstant.acceptedStatus;
    widget.donation.acceptedByAgentId = currentAgentId;

    final donationsList = donationsBox.values.toList();
    final donationIndex = donationsList.indexWhere((d) => d.donationId == widget.donation.donationId);

    if (donationIndex != -1) {
      await donationsBox.putAt(donationIndex, widget.donation);
      widget.onStatusChanged();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delivery accepted successfully!")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(donation: widget.donation),
        ),
            (route) => false,
      );
    }
  }

  void _completeDelivery() async {
    final donationsBox = Hive.box<Donation>(KeysConstant.donationsBox);

    widget.donation.status = KeysConstant.completedStatus;

    final donationsList = donationsBox.values.toList();
    final donationIndex = donationsList.indexWhere((d) => d.donationId == widget.donation.donationId);

    if (donationIndex != -1) {
      await donationsBox.putAt(donationIndex, widget.donation);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delivery marked as completed!")),
      );

      widget.onStatusChanged();
      Navigator.pop(context);
    }
  }

  void _rejectDonation() {
    Navigator.pop(context);
  }
}