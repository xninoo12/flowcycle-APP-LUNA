import 'package:flutter/material.dart';

/// Bottom message input bar for Live AI Chat (Pure Text Composer).
class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSendMessage;

  const ChatInputBar({super.key, required this.onSendMessage});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF2EDF7), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text Input Field
            Expanded(
              child: Container(
                height: 44.0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8FC),
                  borderRadius: BorderRadius.circular(22.0),
                  border: Border.all(
                    color: const Color(0xFFEFE9F3),
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF1E1A3C),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Ask me anything about your cycle...',
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF9E96A8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10.0),

            // Send Button
            GestureDetector(
              onTap: _handleSend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _hasText
                        ? [const Color(0xFF9D84EB), const Color(0xFF7C5CE7)]
                        : [const Color(0xFFDCD6E5), const Color(0xFFCBC4D6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: _hasText
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF7C5CE7,
                            ).withValues(alpha: 0.3),
                            blurRadius: 6.0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
