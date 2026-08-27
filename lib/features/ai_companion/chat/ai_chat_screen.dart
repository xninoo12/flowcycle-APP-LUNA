import 'package:flutter/material.dart';
import '../../../core/data/app_data_manager.dart';
import '../../../core/services/ai_service.dart';
import '../../../shared/providers/app_scope.dart';
import 'models/chat_message.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_bubble.dart';

/// Full-screen Live AI Companion Chat Conversation Screen.
class AiChatScreen extends StatefulWidget {
  final String? initialPrompt;

  const AiChatScreen({super.key, this.initialPrompt});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Default initial greeting
    _messages.add(
      ChatMessage(
        id: 'msg_welcome',
        text:
            "Hello! 🌿 I'm your FlowCycle AI Companion. I'm synced with your cycle data and ready to guide you. How can I help you today?",
        sender: MessageSender.ai,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        quickReplies: const [
          'What should I eat today? 🥗',
          'Tips for better sleep 🌙',
          'Is my period normal? 🌸',
          'Fertility booster advice 💧',
        ],
      ),
    );

    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage(String text) async {
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          text: text,
          sender: MessageSender.user,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _scrollToBottom();

    final controller = AppScope.of(context);
    final userProfile = controller.userProfile;
    final cycleDay = controller.currentCycleDay;
    final phaseName = controller.currentPhaseName;
    final todayLog = controller.getLogForDate(DateTime.now());

    final messageId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    final aiMessage = ChatMessage(
      id: messageId,
      text: '',
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      quickReplies: const [
        'How does this affect my cycle?',
        'What lifestyle tips help most?',
        'Explore related health articles',
      ],
    );

    final stream = AiService.instance.generateAiResponseStream(
      userPrompt: text,
      userProfile: userProfile,
      cycleDay: cycleDay,
      phaseName: phaseName,
      todayLog: todayLog,
    );

    final fullText = StringBuffer();
    bool addedToMessages = false;

    await for (final chunk in stream) {
      if (!mounted) break;
      fullText.write(chunk);
      setState(() {
        _isTyping = false;
        if (!addedToMessages) {
          _messages.add(aiMessage.copyWith(text: fullText.toString()));
          addedToMessages = true;
        } else {
          final index = _messages.indexWhere((m) => m.id == messageId);
          if (index != -1) {
            _messages[index] = _messages[index].copyWith(text: fullText.toString());
          }
        }
      });
      _scrollToBottom();
    }

    if (!addedToMessages && mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(aiMessage.copyWith(text: fullText.toString()));
      });
      _scrollToBottom();
    }

    // Persist interaction to offline data store
    AppDataManager.instance.handleAiChatInteraction(
      prompt: text,
      sessionId: 'main_chat_session',
      userProfile: userProfile,
      cycleDay: cycleDay,
      phaseName: phaseName,
      todayLog: todayLog,
    );
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(
        ChatMessage(
          id: 'msg_welcome_new',
          text:
              "Conversation refreshed! 🌿 What would you like to explore next?",
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
          quickReplies: const [
            'What should I eat today? 🥗',
            'Tips for better sleep 🌙',
            'Is my period normal? 🌸',
          ],
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat cleared 🧹'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF7A708A),
      ),
    );
  }

  void _exportChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chat summary exported to notes 📄'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF7C64E8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18.0),
          color: const Color(0xFF1E1A3C),
          onPressed: () {
            try {
              Navigator.of(context).maybePop();
            } catch (_) {}
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            // Mascot Droplet Avatar with Online Dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3EDFA),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('💧', style: TextStyle(fontSize: 18.0)),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10.0),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'AI Companion',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '● Online & Ready to help',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 20.0,
              color: Color(0xFF7A708A),
            ),
            onSelected: (val) {
              if (val == 'clear') {
                _clearChat();
              } else if (val == 'export') {
                _exportChat();
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF7A708A),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text('Clear Conversation'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(
                      Icons.download_rounded,
                      color: Color(0xFF7A708A),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text('Export Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            // Medical Disclaimer Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              color: const Color(0xFFF4F0FA),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 13.0,
                    color: Color(0xFF7C5CE7),
                  ),
                  SizedBox(width: 6.0),
                  Flexible(
                    child: Text(
                      'AI health assistant • Not intended as medical diagnosis',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6E6875),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Message Feed
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildTypingIndicator();
                  }
                  final message = _messages[index];
                  return ChatMessageBubble(
                    message: message,
                    onQuickReplySelected: _handleSendMessage,
                  );
                },
              ),
            ),

            // Input Bar (Text Only)
            ChatInputBar(onSendMessage: _handleSendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(18.0),
              ),
              border: Border.all(color: const Color(0xFFEFE9F3), width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4.0),
                _buildDot(1),
                const SizedBox(width: 4.0),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: 6.0,
      height: 6.0,
      decoration: const BoxDecoration(
        color: Color(0xFF7C5CE7),
        shape: BoxShape.circle,
      ),
    );
  }
}
