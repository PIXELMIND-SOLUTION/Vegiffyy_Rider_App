// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/models/ChatModel/chat_message.dart';
import 'package:veggify_delivery_app/provider/ChatProvider/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String deliveryBoyId;
  final String userId;
  final String title;
  const ChatScreen({
    Key? key,
    required this.deliveryBoyId,
    required this.userId,
    this.title = 'Chat',
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();

    print("llllllllllllllllllllllllllllllllllllll${widget.deliveryBoyId}");
        print("llllllllllllllllllllllllllllllllllllll${widget.userId}");
    print("llllllllllllllllllllllllllllllllllllll${widget.deliveryBoyId}");

    // set scroll callback after provider is created (post frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<ChatProvider>(context, listen: false);
      prov.setScrollCallback(() {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _onSend(ChatProvider provider) async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    setState(() => _sending = true);
    final ok = await provider.sendMessage(text);
    setState(() => _sending = false);
    if (ok) {
      _controller.clear();
      _scrollToBottom();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send message')));
    }
  }

  Widget _buildBubble(ChatMessage msg) {
    print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkhhhhhhhhhh${msg.senderType.toLowerCase()}");
    final isUser = msg.senderType.toLowerCase() != 'rider';
    final alignment = isUser ? MainAxisAlignment.start : MainAxisAlignment.end;
    final bg = isUser ? Colors.green[50] : Colors.grey.shade200;
    final textColor = Colors.black87;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isUser ? 12 : 0),
      bottomRight: Radius.circular(isUser ? 0 : 12),
    );
    final time = DateFormat('hh:mm a').format(msg.timestamp);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: bg, borderRadius: radius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(msg.message, style: TextStyle(color: textColor, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text(time, style: TextStyle(color: Colors.black45, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (_) => ChatProvider(deliveryBoyId: widget.deliveryBoyId, userId: widget.userId, usePollingFallback: true),
      child: Consumer<ChatProvider>(builder: (context, provider, _) {
        // scroll to bottom when messages change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.messages.isNotEmpty) _scrollToBottom();
        });

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black87), onPressed: () => Navigator.of(context).maybePop()),
            title: Row(
              children: [
                // small avatar placeholder
                CircleAvatar(radius: 16, backgroundColor: Colors.grey[200], child: Icon(Icons.person, color: Colors.grey[700])),
                const SizedBox(width: 10),
                Text(widget.title, style: const TextStyle(color: Colors.black)),
                const SizedBox(width: 8),
                if (provider.socketConnected)
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)), child: const Text('Live', style: TextStyle(color: Colors.green, fontSize: 12))),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: provider.loading && provider.messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scroll,
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          itemCount: provider.messages.length,
                          itemBuilder: (context, index) {
                            final msg = provider.messages[index];
                            return _buildBubble(msg);
                          },
                        ),
                ),

                // Input area
                Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, -1))]),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _onSend(provider),
                          decoration: InputDecoration(
                            hintText: 'Text here',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        mini: true,
                        onPressed: _sending ? null : () => _onSend(provider),
                        backgroundColor: _sending ? Colors.grey : Colors.green,
                        child: _sending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
