import 'package:flutter/material.dart';

/// Chat summary model
class AiChatSummary {
  final String id;
  final String title;
  final String snippet;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const AiChatSummary({
    required this.id,
    required this.title,
    required this.snippet,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

/// "Let's talk" Chat History Section for AI Companion screen.
class AiChatHistorySection extends StatelessWidget {
  final VoidCallback? onNewChat;
  final ValueChanged<AiChatSummary>? onChatSelected;
  final VoidCallback? onViewAllChats;

  static const List<AiChatSummary> defaultChats = [
    AiChatSummary(
      id: '1',
      title: 'Fertile window & chances',
      snippet: 'You asked about your chances this cycle...',
      timestamp: '10:30 AM',
      icon: Icons.chat_bubble_outline_rounded,
      iconColor: Color(0xFF8B5CF6),
      iconBgColor: Color(0xFFEDE9FE),
    ),
    AiChatSummary(
      id: '2',
      title: 'Nutrition for fertility',
      snippet: 'Here are some fertility-boosting foods...',
      timestamp: 'Yesterday',
      icon: Icons.ramen_dining_outlined,
      iconColor: Color(0xFFE84855),
      iconBgColor: Color(0xFFFFEEF0),
    ),
    AiChatSummary(
      id: '3',
      title: 'Managing stress',
      snippet: "Let's talk about simple ways to manage stress...",
      timestamp: '2 days ago',
      icon: Icons.self_improvement_rounded,
      iconColor: Color(0xFF10B981),
      iconBgColor: Color(0xFFE8F5E9),
    ),
  ];

  const AiChatHistorySection({
    super.key,
    this.onNewChat,
    this.onChatSelected,
    this.onViewAllChats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header: "Let's talk" + "New chat ⊕"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Let's talk",
              style: TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w900,
                fontSize: 15.0,
                color: Color(0xFF1E1A3C),
                letterSpacing: -0.2,
              ),
            ),
            InkWell(
              onTap: onNewChat,
              borderRadius: BorderRadius.circular(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'New chat',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF4D6D),
                    ),
                  ),
                  SizedBox(width: 3.0),
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 14.0,
                    color: Color(0xFFFF4D6D),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8.0),

        // 2. Chat Items Card Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: const Color(0xFFF1ECF5), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1A3C).withValues(alpha: 0.025),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ...defaultChats.map((chat) => _buildChatRow(chat)),

              const Divider(height: 1.0, color: Color(0xFFF1ECF5)),

              // 3. "View all chats →"
              InkWell(
                onTap: onViewAllChats,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'View all chats',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 13.0,
                        color: Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatRow(AiChatSummary chat) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChatSelected?.call(chat),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 9.0,
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: chat.iconBgColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Icon(chat.icon, color: chat.iconColor, size: 16.0),
                ),
              ),

              const SizedBox(width: 10.0),

              // Title and Snippet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.title,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1A3C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      chat.snippet,
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Color(0xFF7A708A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6.0),

              // Timestamp
              Text(
                chat.timestamp,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7A708A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
