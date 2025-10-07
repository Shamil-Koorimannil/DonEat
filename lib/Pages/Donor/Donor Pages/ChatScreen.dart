import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../Concense/keys_consence.dart';
import '../../../Models/DonEat_model.dart';
import '../../Donor/Donor Pages/Donor Home.dart';
import '../../Agent/Agent Pages/Agent Home.dart';
import '../Donor Widgets/header.dart';

class ChatScreen extends StatefulWidget {
  final Donation donation;

  const ChatScreen({super.key, required this.donation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  late String _currentUserId;
  late String _currentUserName;
  late String _currentUserType;
  String? _otherUserName;
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadOtherUserName();
    _loadChatMessages();
  }

  void _loadUserInfo() async {
    final sessionBox = Hive.box(KeysConstant.sessionBox);
    final userType = sessionBox.get(KeysConstant.userType);

    if (userType == KeysConstant.donorUserType) {
      _currentUserType = KeysConstant.donorUserType;

      final donorsBox = Hive.box<Donor>(KeysConstant.donorsBox);
      final currentDonorIndex = sessionBox.get(KeysConstant.loggedInUserIndex);
      if (currentDonorIndex != null) {
        final donor = donorsBox.getAt(currentDonorIndex);
        _currentUserEmail = donor?.email;
        _currentUserId = 'donor_${donor?.email ?? 'unknown'}';
        _currentUserName = donor?.name ?? 'You';
      } else {
        _currentUserId = 'donor_unknown';
        _currentUserName = 'You';
      }
    } else {
      _currentUserType = KeysConstant.agentUserType;

      final agentsBox = Hive.box<Agent>(KeysConstant.agentsBox);
      final currentAgentIndex = sessionBox.get(KeysConstant.loggedInUserIndex);
      if (currentAgentIndex != null) {
        final agent = agentsBox.getAt(currentAgentIndex);
        _currentUserEmail = agent?.email;
        _currentUserId = 'agent_${agent?.email ?? 'unknown'}';
        _currentUserName = agent?.name ?? 'Agent';
      } else {
        _currentUserId = 'agent_unknown';
        _currentUserName = 'Agent';
      }
    }

    setState(() {});
  }

  void _loadOtherUserName() async {
    final sessionBox = Hive.box(KeysConstant.sessionBox);
    final userType = sessionBox.get(KeysConstant.userType);

    try {
      if (userType == KeysConstant.donorUserType) {
        if (widget.donation.agentEmail != null) {
          final agentsBox = Hive.box<Agent>(KeysConstant.agentsBox);
          final agents = agentsBox.values.toList();
          final acceptingAgent = agents.firstWhere(
                  (agent) => agent.email == widget.donation.agentEmail,
              orElse: () => Agent(name: 'Agent', email: '', password: '', phone: '')
          );
          _otherUserName = acceptingAgent.name ?? 'Agent';
        } else {
          _otherUserName = 'Agent';
        }
      } else {
        if (widget.donation.donorEmail != null) {
          final donorsBox = Hive.box<Donor>(KeysConstant.donorsBox);
          final donors = donorsBox.values.toList();
          final donor = donors.firstWhere(
                  (donor) => donor.email == widget.donation.donorEmail,
              orElse: () => Donor(name: 'Donor', email: '', password: '', phone: '')
          );
          _otherUserName = donor.name ?? 'Donor';
        } else {
          _otherUserName = 'Donor';
        }
      }
    } catch (e) {
      print('Error loading other user name: $e');
      _otherUserName = userType == KeysConstant.donorUserType ? 'Agent' : 'Donor';
    }

    setState(() {});
  }

  void _loadChatMessages() {
    try {
      final chatBox = Hive.box<ChatMessage>(KeysConstant.chatMessagesBox);

      _messages = chatBox.values
          .where((message) => message.donationId == widget.donation.donationId).toList()..sort((a, b) => (a.timestamp ?? DateTime.now()).compareTo(b.timestamp ?? DateTime.now()));

      setState(() {});
    } catch (e) {
      print('Error loading chat messages: $e');
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final chatBox = Hive.box<ChatMessage>(KeysConstant.chatMessagesBox);

      final newMessage = ChatMessage(
        donationId: widget.donation.donationId!,
        senderId: _currentUserId,
        message: _messageController.text.trim(),
        timestamp: DateTime.now(),
        senderName: _currentUserName,
        senderType: _currentUserType,
        senderEmail: _currentUserEmail,
      );

      chatBox.add(newMessage);

      setState(() {
        _messages.add(newMessage);
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  void _navigateBack() {
    final sessionBox = Hive.box(KeysConstant.sessionBox);
    final userType = sessionBox.get(KeysConstant.userType);

    if (userType == KeysConstant.donorUserType) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DonorHome()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AgentHome()),
            (route) => false,
      );
    }
  }

  String _getDisplayName(ChatMessage message) {
    if (message.senderId?.contains('system') == true || message.senderType == 'system') {
      return message.senderName ?? 'System';
    }

    if (message.senderId == _currentUserId) {
      return 'You';
    }

    return _otherUserName ??
        (message.senderType == KeysConstant.donorUserType ? 'Donor' : 'Agent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: DonorHead(),
                child: Container(
                  height: 200,
                  color: const Color(0xFFFF863B),
                  alignment: Alignment.center,
                  child: Text(
                    "Chat",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
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
                    onPressed: _navigateBack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7C2A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF7C2A)),
            ),
            child: Row(
              children: [
                const Icon(Icons.fastfood, color: Color(0xFFFF7C2A)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.donation.foodName ?? 'No Food Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${widget.donation.quantity ?? 0} people • ${widget.donation.location ?? 'No Location'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (_otherUserName != null)
                        Text(
                          'Chatting with: $_otherUserName',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF7C2A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _messages.isEmpty
                ? const Center(
              child: Text(
                "No messages yet\nStart the conversation!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.senderId == _currentUserId;
                final displayName = _getDisplayName(message);

                return ChatBubble(
                  message: message.message ?? '',
                  isUser: isUser,
                  senderName: displayName,
                  timestamp: message.timestamp ?? DateTime.now(),
                  otherUserName: _otherUserName,
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFFF7C2A)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7C2A),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String senderName;
  final DateTime timestamp;
  final String? otherUserName;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.senderName,
    required this.timestamp,
    this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(false),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 50 : 8,
                right: isUser ? 8 : 50,
              ),
              child: Column(
                crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isUser)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Text(
                        senderName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFFF7C2A) : Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: isUser ?  const Radius.circular(20) : const Radius.circular(4),
                        topRight: isUser ?  const Radius.circular(4) : const Radius.circular(20),
                        bottomLeft:const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                    child: Text(
                      _formatTime(timestamp),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) _buildAvatar(true),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    final isSystemMessage = !isUser && senderName == 'System';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isUser
                ? const Color(0xFFFF7C2A)
                : (isSystemMessage ? Colors.green : Colors.blue),
            child: Icon(
              isUser
                  ? Icons.person
                  : (isSystemMessage ? Icons.headset_mic_outlined : Icons.person),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isUser ? 'You' : senderName,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}