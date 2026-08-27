import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Modal dialog for setting up or entering a 4-digit Passcode PIN.
class PinLockDialog extends StatefulWidget {
  final bool isSettingUp;
  final ValueChanged<String>? onPinCompleted;

  const PinLockDialog({
    super.key,
    this.isSettingUp = true,
    this.onPinCompleted,
  });

  @override
  State<PinLockDialog> createState() => _PinLockDialogState();
}

class _PinLockDialogState extends State<PinLockDialog> {
  String _enteredPin = '';
  String _confirmedPin = '';
  bool _isConfirming = false;
  String? _errorMessage;

  void _handleNumberPress(String digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += digit;
        _errorMessage = null;
      });

      if (_enteredPin.length == 4) {
        if (widget.isSettingUp && !_isConfirming) {
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _confirmedPin = _enteredPin;
                _enteredPin = '';
                _isConfirming = true;
              });
            }
          });
        } else if (widget.isSettingUp && _isConfirming) {
          if (_enteredPin == _confirmedPin) {
            widget.onPinCompleted?.call(_enteredPin);
            Navigator.pop(context, _enteredPin);
          } else {
            setState(() {
              _errorMessage = 'PINs did not match. Try again.';
              _enteredPin = '';
              _confirmedPin = '';
              _isConfirming = false;
            });
          }
        } else {
          // Direct PIN entry verification
          widget.onPinCompleted?.call(_enteredPin);
          Navigator.pop(context, _enteredPin);
        }
      }
    }
  }

  void _handleBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF10B981),
                size: 26,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isConfirming ? 'Confirm 4-Digit PIN' : 'Set Up 4-Digit PIN',
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E1A3C),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isConfirming
                  ? 'Re-enter your passcode to confirm'
                  : 'Enter a 4-digit passcode to lock FlowCycle',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF7A708A),
              ),
            ),
            const SizedBox(height: 24),

            // 4 PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? AppColors.primary
                        : const Color(0xFFFAF7F5),
                    border: Border.all(
                      color: isFilled
                          ? AppColors.primary
                          : const Color(0xFFEDE8E0),
                      width: 2,
                    ),
                  ),
                );
              }),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Keypad
            _buildKeypad(),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7A708A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        for (int r = 0; r < 3; r++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int c = 1; c <= 3; c++) _buildKeypadButton('${r * 3 + c}'),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 56, height: 56),
              _buildKeypadButton('0'),
              InkWell(
                onTap: _handleBackspace,
                borderRadius: BorderRadius.circular(28),
                child: const SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Color(0xFF7A708A),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return InkWell(
      onTap: () => _handleNumberPress(digit),
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F5),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEDE8E0)),
        ),
        child: Center(
          child: Text(
            digit,
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E1A3C),
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
