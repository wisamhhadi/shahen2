import 'dart:convert';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:almandobUAE/Widgets/appbar.dart';

class Chat extends StatefulWidget {
  final int mandobId;
  const Chat({super.key, required this.mandobId});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

 void _connectWebSocket() {
  channel = WebSocketChannel.connect(
    Uri.parse('ws://109.237.26.174/ws/chat/${widget.mandobId}/'),
  );

 channel.stream.listen(
  (data) {
    try {
      final decoded = jsonDecode(data);
      print("Received data: $decoded");

      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey("error")) {
          print("Error from server: ${decoded['error']}");
          return;
        }

        setState(() {
          if (decoded['type'] == 'message_history') {
            final historyMessages = decoded['messages'] as List?;
            if (historyMessages != null) {
              _messages.clear(); // تنظيف الرسائل القديمة أولاً
              _messages.addAll(historyMessages.cast<Map<String, dynamic>>()
                .where((m) => m['message']?.toString().trim().isNotEmpty ?? false));
            }
          } else if (decoded['message']?.toString().trim().isNotEmpty ?? false) {
            _messages.add(decoded);
          }
        });
      }
    } catch (e) {
      print("Error decoding WebSocket message: $e");
    }
  },
  onError: (error) => print("WebSocket error: $error"),
  onDone: () => print("WebSocket closed"),
);

  // Send history request after connection is established
  channel.ready.then((_) {
    final historyRequest = jsonEncode({
      "type": "get_history",
      // You might need to add other parameters if required by server
    });
    channel.sink.add(historyRequest);
    print("Sent history request: $historyRequest");
  });
}
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = {
      'message': _controller.text.trim(),
      'mandob_id': widget.mandobId,
    };

    channel.sink.add(jsonEncode(message));
    _controller.clear();
  }

  bool _isFromMandob(Map<String, dynamic> message) {
    final sender = message['sender'];
    if (sender == null) return false;
    return sender['type'] == 'mandob';
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final msgText = message['message']?.toString() ?? '';
    if (msgText.trim().isEmpty) return const SizedBox.shrink();

    final isMandob = _isFromMandob(message);
    final timestamp = message['timestamp']?.toString() ?? '';

    return Align(
      alignment: isMandob ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isMandob ? Colors.blueAccent : CustomColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(isMandob ? 20 : 0),
              bottomRight: Radius.circular(isMandob ? 0 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMandob ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msgText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: "font",
                  height: 1.3,
                ),
                textAlign: TextAlign.start,
              ),
              if (timestamp.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatTimestamp(timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الدردشة",
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[_messages.length - 1 - index];
                  return _buildMessageItem(msg);
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.07),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالة...',
                      hintStyle: TextStyle(fontFamily: "font"),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _controller.text.trim().isEmpty
                          ? null
                          : IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: () => _controller.clear(),
                            ),
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _controller.text.trim().isEmpty
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
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
