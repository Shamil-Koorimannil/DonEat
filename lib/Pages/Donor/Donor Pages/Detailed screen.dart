import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Concense/keys_consence.dart';
import '../../../Models/DonEat_model.dart';
import 'ChatScreen.dart';
import 'Donor Home.dart';

class DetailsScreen extends StatefulWidget {
  final Donation donation;

  const DetailsScreen({super.key, required this.donation});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Future<void> _cancelDonation() async {
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
      final donationsBox = Hive.box<Donation>(KeysConstant.donationsBox);

      final donationsList = donationsBox.values.toList();
      final donationIndex = donationsList.indexWhere((d) => d.donationId == widget.donation.donationId);

      if (donationIndex != -1) {
        await donationsBox.deleteAt(donationIndex);
        await _deleteChatMessages(widget.donation.donationId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Donation cancelled successfully")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => DonorHome()),
              (route) => false,
        );
      }
    }
  }

  Future<void> _deleteChatMessages(String donationId) async {
    final chatBox = Hive.box<ChatMessage>(KeysConstant.chatMessagesBox);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7C2A),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
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
                const Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
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
                        const Text("Food name",
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 10),
                        _buildReadOnlyField(widget.donation.foodName),
                        const SizedBox(height: 20),
                        const Text("Pickup location",
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 10),
                        _buildLocationField(widget.donation.location),
                        const SizedBox(height: 20),
                        const Text("Pickup Date",
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 10),
                        _buildReadOnlyField(widget.donation.date),
                        const SizedBox(height: 20),
                        const Text("Pickup Time",
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 10),
                        _buildReadOnlyField(widget.donation.time),
                        const SizedBox(height: 20),
                        const Text("Contact number",
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 10),
                        _buildReadOnlyField(widget.donation.contact),
                        const SizedBox(height: 30),
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
                                "${widget.donation.quantity}",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("5", style: TextStyle(color: Colors.black54)),
                            Expanded(
                              child: Slider(
                                value: widget.donation.quantity.toDouble(),
                                min: 5,
                                max: 300,
                                divisions: 295,
                                activeColor: const Color(0xFFFF7C2A),
                                inactiveColor: Colors.black26,
                                onChanged: null,
                              ),
                            ),
                            const Text("300", style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Uploaded Images:",
                            style: TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 10),
                        if (widget.donation.imagePaths != null && widget.donation.imagePaths!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: widget.donation.imagePaths!.map((imagePath) {
                              return _buildImageBox(imagePath);
                            }).toList(),
                          )
                        else
                          const Text("No images uploaded",
                              style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.donation.status),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getStatusIcon(widget.donation.status),
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Status: ${_getStatusText(widget.donation.status)}",
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
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _cancelDonation,
                            child: const Text(
                              "Cancel Donation",
                              style: TextStyle(
                                color: Color(0xFFFF863B),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7C2A),
                              minimumSize: const Size(double.infinity, 50),
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
                              "Go to chat",
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFF7C2A)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildLocationField(String location) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFF7C2A)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              location,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.arrow_forward, color: Color(0xFFFF7C2A)),
        ],
      ),
    );
  }

  Widget _buildImageBox(String imagePath) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFF7C2A)),
      ),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.image, color: Colors.black87, size: 50),
          );
        },
      ),
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
        return "Accepted by Agent";
      case KeysConstant.completedStatus:
        return "Completed";
      default:
        return "Unknown";
    }
  }
}