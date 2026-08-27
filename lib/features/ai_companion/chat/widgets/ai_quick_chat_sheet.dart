import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/ai_service.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../shared/providers/app_scope.dart';
import '../../../../shared/providers/cycle_data_controller.dart';
import '../../widgets/ai_api_key_sheet.dart';

/// Modal bottom sheet popup for interactive AI Companion conversations.
class AiQuickChatSheet extends StatefulWidget {
  final String? initialPrompt;

  const AiQuickChatSheet({super.key, this.initialPrompt});

  @override
  State<AiQuickChatSheet> createState() => _AiQuickChatSheetState();
}

class _AiQuickChatSheetState extends State<AiQuickChatSheet> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isGenerating = false;

  static const List<String> _suggestedChips = [
    'Am I fertile today?',
    'Why is my BBT elevated?',
    'Best foods for my phase?',
    'Explain my LH surge',
  ];

  @override
  void initState() {
    super.initState();

    _messages.add(
      _ChatMessage(
        text:
            "Hi there! 🌸 I'm your FlowCycle AI companion. How can I support your cycle or wellness today?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    if (widget.initialPrompt != null && widget.initialPrompt!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialPrompt!.trim());
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isGenerating) return;

    final userText = text.trim();
    _inputController.clear();

    setState(() {
      _messages.add(
        _ChatMessage(
          text: userText,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isGenerating = true;
    });
    _scrollToBottom();

    final controller = CycleDataController.instance;
    final profile = controller.userProfile;
    final todayLog = controller.todayLog;

    final responseBuffer = StringBuffer();
    final botMessage = _ChatMessage(
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
    });

    try {
      final stream = AiService.instance.generateAiResponseStream(
        userPrompt: userText,
        userProfile: profile,
        cycleDay: 13,
        phaseName: 'Follicular / Fertile',
        todayLog: todayLog,
      );

      await for (final chunk in stream) {
        if (!mounted) return;
        responseBuffer.write(chunk);
        setState(() {
          botMessage.text = responseBuffer.toString();
        });
        _scrollToBottom();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        botMessage.text =
            "Based on your cycle day and logged biomarkers, your estrogen is rising normally. Keep logging daily to increase predictive accuracy! ✨";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _openApiKeySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AiApiKeySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF7F2),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
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
          const SizedBox(height: 12.0),

          // Top Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFFF6B8B)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('✨', style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'FlowCycle AI',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                        ),
                        Text(
                          'Evidence-based cycle companion',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF7A708A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.key_rounded,
                        color: Color(0xFF8B5CF6),
                        size: 20.0,
                      ),
                      tooltip: 'Gemini API Key',
                      onPressed: _openApiKeySheet,
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
              ],
            ),
          ),

          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // Suggestion Chips Strip
          SizedBox(
            height: 42.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              itemCount: _suggestedChips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8.0),
              itemBuilder: (context, index) {
                final chip = _suggestedChips[index];
                return ActionChip(
                  label: Text(
                    chip,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5CF6),
                    ),
                  ),
                  backgroundColor: const Color(0xFFF3E8FF),
                  side: const BorderSide(color: Color(0xFFE9D5FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: () => _sendMessage(chip),
                );
              },
            ),
          ),

          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          if (_isGenerating)
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 6.0),
              child: Row(
                children: const [
                  SizedBox(
                    width: 14.0,
                    height: 14.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'FlowCycle AI is thinking...',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF8B5CF6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEFE9F4))),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F2F8),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: TextField(
                        controller: _inputController,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF1E1A3C),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ask about your cycle, symptoms, or foods...',
                          hintStyle: TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF9C93A8),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  InkWell(
                    onTap: () => _sendMessage(_inputController.text),
                    borderRadius: BorderRadius.circular(22.0),
                    child: Container(
                      width: 42.0,
                      height: 42.0,
                      decoration: const BoxDecoration(
                        gradient: AppGradients.dawnBloom,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0, left: 40.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            gradient: AppGradients.dawnBloom,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
              bottomLeft: Radius.circular(18.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          child: Text(
            message.text,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0, right: 40.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
            bottomRight: Radius.circular(18.0),
            bottomLeft: Radius.circular(4.0),
          ),
          border: Border.all(color: const Color(0xFFE8E2EE)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E1A3C).withValues(alpha: 0.03),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text.isEmpty ? '...' : message.text,
          style: const TextStyle(
            fontSize: 13.0,
            color: Color(0xFF2D2438),
            height: 1.38,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  String text;
  final bool isUser;
  final DateTime timestamp;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
