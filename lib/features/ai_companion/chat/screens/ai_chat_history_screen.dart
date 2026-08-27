import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Screen allowing users to view, search, resume, and manage past AI conversations.
class AiChatHistoryScreen extends StatefulWidget {
  const AiChatHistoryScreen({super.key});

  @override
  State<AiChatHistoryScreen> createState() => _AiChatHistoryScreenState();
}

class _AiChatHistoryScreenState extends State<AiChatHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _chatSessions = [
    {
      'id': 'chat_1',
      'title': 'Luteal Phase Nutrition & Cravings',
      'preview':
          'Recommended zinc-rich pumpkin seeds, salmon, and magnesium for restful sleep.',
      'date': 'Yesterday, 8:15 PM',
      'messageCount': 8,
      'emoji': '🥗',
    },
    {
      'id': 'chat_2',
      'title': 'Ovulation Test Strip Interpretation',
      'preview':
          'LH surge was detected on cycle day 13, indicating peak fertility window.',
      'date': 'May 12, 11:30 AM',
      'messageCount': 12,
      'emoji': '💧',
    },
    {
      'id': 'chat_3',
      'title': 'Sleep Quality & Evening Body Temperature',
      'preview':
          'Tips on room temperature optimization and avoiding blue light.',
      'date': 'May 9, 9:45 PM',
      'messageCount': 5,
      'emoji': '🌙',
    },
    {
      'id': 'chat_4',
      'title': 'Period Cramp Relief & Gentle Yoga',
      'preview':
          'Child pose and magnesium glycinate recommended for menstrual soothing.',
      'date': 'May 4, 3:20 PM',
      'messageCount': 6,
      'emoji': '🌸',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openChat(String prompt) {
    try {
      context.push(AppRoutes.aiChatPath, extra: {'prompt': prompt});
    } catch (_) {}
  }

  void _deleteChat(int index) {
    final deleted = _chatSessions[index]['title'];
    setState(() {
      _chatSessions.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "$deleted"'),
        backgroundColor: const Color(0xFF7A708A),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _chatSessions.where((s) {
      final q = _searchQuery.toLowerCase();
      final title = (s['title'] as String).toLowerCase();
      final preview = (s['preview'] as String).toLowerCase();
      return q.isEmpty || title.contains(q) || preview.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E1A3C),
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chat History',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1A3C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: const Color(0xFFEFE9F3)),
                  boxShadow: AppShadows.card,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search past conversations...',
                    hintStyle: TextStyle(
                      color: Color(0xFFAAA3B8),
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Color(0xFF7C64E8),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // Chat Threads List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3EDFA),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('💬', style: TextStyle(fontSize: 28)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No conversations found',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1A3C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Start a new chat to ask your AI Guide anything!',
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFF7A708A),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final chat = filtered[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: AppRadius.medium,
                            border: Border.all(color: const Color(0xFFEFE9F3)),
                            boxShadow: AppShadows.card,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: AppRadius.medium,
                              onTap: () => _openChat(chat['title'] as String),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3EDFA),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          chat['emoji'] as String,
                                          style: const TextStyle(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  chat['title'] as String,
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: const Color(
                                                          0xFF1E1A3C,
                                                        ),
                                                        fontSize: 13.5,
                                                      ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                icon: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Color(0xFFAAA3B8),
                                                  size: 18,
                                                ),
                                                onPressed: () =>
                                                    _deleteChat(index),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            chat['preview'] as String,
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: const Color(
                                                    0xFF7A708A,
                                                  ),
                                                  fontSize: 12,
                                                  height: 1.35,
                                                ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                chat['date'] as String,
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                      color: const Color(
                                                        0xFFAAA3B8,
                                                      ),
                                                      fontSize: 11,
                                                    ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFAF7F5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${chat['messageCount']} messages',
                                                  style: AppTextStyles.caption
                                                      .copyWith(
                                                        color: const Color(
                                                          0xFF7C64E8,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 10.5,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Start New Chat Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _openChat('New Conversation'),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text(
                    'Start New Chat ✦',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C64E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
}
