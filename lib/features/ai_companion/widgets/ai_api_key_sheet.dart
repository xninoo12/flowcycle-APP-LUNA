import 'package:flutter/material.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal bottom sheet allowing users to input and validate their Gemini AI API Key
/// or switch back to the built-in offline clinical intelligence engine.
class AiApiKeySheet extends StatefulWidget {
  final VoidCallback? onKeyUpdated;

  const AiApiKeySheet({super.key, this.onKeyUpdated});

  @override
  State<AiApiKeySheet> createState() => _AiApiKeySheetState();
}

class _AiApiKeySheetState extends State<AiApiKeySheet> {
  late TextEditingController _keyController;
  bool _isTesting = false;
  String? _statusMessage;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(
      text: AiService.instance.apiKey,
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _handleTestAndSave() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      AiService.instance.setApiKey(null);
      setState(() {
        _statusMessage =
            'API Key removed. Switched to Built-in Clinical Engine.';
        _isSuccess = true;
      });
      widget.onKeyUpdated?.call();
      return;
    }

    setState(() {
      _isTesting = true;
      _statusMessage = null;
    });

    final success = await AiService.instance.testConnection(key);

    if (!mounted) return;

    if (success) {
      AiService.instance.setApiKey(key);
      setState(() {
        _isTesting = false;
        _isSuccess = true;
        _statusMessage = 'Connection successful! Gemini 1.5 Flash activated.';
      });
      widget.onKeyUpdated?.call();
    } else {
      // In case user provided a dummy or unverified key in offline test mode,
      // we still allow saving with a friendly clinical fallback notice.
      AiService.instance.setApiKey(key);
      setState(() {
        _isTesting = false;
        _isSuccess = false;
        _statusMessage =
            'API Key saved. If offline or quota exceeded, clinical engine will automatically handle responses.';
      });
      widget.onKeyUpdated?.call();
    }
  }

  void _handleClearKey() {
    AiService.instance.setApiKey(null);
    _keyController.clear();
    setState(() {
      _isSuccess = true;
      _statusMessage = 'Switched to Built-in Clinical Engine.';
    });
    widget.onKeyUpdated?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasKey = AiService.instance.hasApiKey;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDD6FE),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.vpn_key_rounded,
                  color: Color(0xFF7C5CE7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Intelligence Configuration',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E1A3C),
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      hasKey
                          ? 'Active: Google Gemini 1.5 Flash'
                          : 'Active: FlowCycle Clinical Engine',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: hasKey
                            ? const Color(0xFF10B981)
                            : const Color(0xFF7C5CE7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'Provide your Google Gemini API Key to enable generative conversation, or use our built-in gynecological cycle intelligence without an API key.',
            style: AppTextStyles.caption.copyWith(
              fontSize: 12,
              color: const Color(0xFF6B627A),
              height: 1.35,
            ),
          ),

          const SizedBox(height: 16),

          // API Key Text Field
          TextField(
            controller: _keyController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter Gemini API Key (e.g. AIzaSy...)',
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFFA59FA9),
              ),
              prefixIcon: const Icon(
                Icons.key_rounded,
                size: 18,
                color: Color(0xFF7C5CE7),
              ),
              suffixIcon: _keyController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: _handleClearKey,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.medium,
                borderSide: const BorderSide(color: Color(0xFFE5E5EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.medium,
                borderSide: const BorderSide(
                  color: Color(0xFF7C5CE7),
                  width: 1.5,
                ),
              ),
            ),
          ),

          if (_statusMessage != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _isSuccess == true
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  size: 14,
                  color: _isSuccess == true
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _statusMessage!,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: _isSuccess == true
                          ? const Color(0xFF10B981)
                          : const Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),

          // Save / Test Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _isTesting ? null : _handleTestAndSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C5CE7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isTesting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Save & Activate AI Engine',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
