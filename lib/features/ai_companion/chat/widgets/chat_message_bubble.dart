import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';

/// Message bubble widget supporting user and AI companion conversations with actions.
class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final ValueChanged<String>? onQuickReplySelected;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onQuickReplySelected,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _isLiked = false;

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.message.text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied insight to clipboard 📋'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF7C64E8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isUser = widget.message.sender == MessageSender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                // AI Droplet Avatar
                Container(
                  width: 28.0,
                  height: 28.0,
                  margin: const EdgeInsets.only(right: 8.0, bottom: 2.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3EDFA),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('💧', style: TextStyle(fontSize: 14.0)),
                  ),
                ),
              ],

              // Bubble Container
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF7C5CE7) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18.0),
                      topRight: const Radius.circular(18.0),
                      bottomLeft: Radius.circular(isUser ? 18.0 : 4.0),
                      bottomRight: Radius.circular(isUser ? 4.0 : 18.0),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: const Color(0xFFEFE9F3),
                            width: 1.0,
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? const Color(0xFF7C5CE7).withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message.text,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                      color: isUser ? Colors.white : const Color(0xFF1E1A3C),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Action row for AI messages (Copy & Helpful 👍)
          if (!isUser) ...[
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _copyToClipboard(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF8FC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.copy_rounded,
                            size: 11,
                            color: Color(0xFF7A708A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Copy',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF7A708A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isLiked = !_isLiked);
                      if (_isLiked) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thanks for your feedback! 👍'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _isLiked
                            ? const Color(0xFFE8F8F0)
                            : const Color(0xFFFAF8FC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isLiked
                                ? Icons.thumb_up_rounded
                                : Icons.thumb_up_outlined,
                            size: 11,
                            color: _isLiked
                                ? const Color(0xFF10B981)
                                : const Color(0xFF7A708A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Helpful',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: _isLiked
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF7A708A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Quick Replies (if present on AI message)
          if (!isUser &&
              widget.message.quickReplies != null &&
              widget.message.quickReplies!.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: widget.message.quickReplies!.map((reply) {
                  return GestureDetector(
                    onTap: () => widget.onQuickReplySelected?.call(reply),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF8FC),
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: const Color(0xFFE5DBFF),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        reply,
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C5CE7),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
