import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for AI Chat History with search and resume conversation actions.
class AiChatHistorySheet extends StatefulWidget {
  final ValueChanged<String>? onChatSelected;
  final VoidCallback? onNewChat;

  const AiChatHistorySheet({
    super.key,
    this.onChatSelected,
    this.onNewChat,
  });

  @override
  State<AiChatHistorySheet> createState() => _AiChatHistorySheetState();
}

class _AiChatHistorySheetState extends State<AiChatHistorySheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<_ChatRecord> _sampleChats = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChats = _sampleChats.where((chat) {
      if (_searchQuery.isEmpty) return true;
      return chat.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          chat.preview.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12.0),
          Container(
            width: 44.0,
            height: 4.5,
            decoration: BoxDecoration(
              color: const Color(0xFFE2DCE8),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(height: 14.0),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text('💬', style: TextStyle(fontSize: 18.0)),
                          SizedBox(width: 6.0),
                          Text(
                            'Conversations',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1A3C),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Your past AI cycle dialogues and advice',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF7A708A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7A708A),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFE8E2EE)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v.trim()),
                decoration: const InputDecoration(
                  hintText: 'Search chat history...',
                  hintStyle: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF9C93A8),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF8B5CF6),
                    size: 20.0,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // List of Chat Records
          Flexible(
            child: filteredChats.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'No matching conversations found.',
                        style: TextStyle(color: Color(0xFF7A708A)),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20.0),
                    itemCount: filteredChats.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      final chat = filteredChats[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onChatSelected?.call(chat.title);
                        },
                        borderRadius: BorderRadius.circular(18.0),
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.0),
                            border: Border.all(color: const Color(0xFFE8E2EE)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F2F8),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    chat.emoji,
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.title,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1E1A3C),
                                      ),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      chat.preview,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xFF7A708A),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      chat.timeAgo,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF8B5CF6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 13.0,
                                color: Color(0xFFB8B0C4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Bottom New Chat Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(
              label: 'Start New Conversation ✦',
              gradient: AppGradients.dawnBloom,
              height: 48.0,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onNewChat?.call();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatRecord {
  final String title;
  final String preview;
  final String timeAgo;
  final String emoji;

  const _ChatRecord({
    required this.title,
    required this.preview,
    required this.timeAgo,
    required this.emoji,
  });
}
