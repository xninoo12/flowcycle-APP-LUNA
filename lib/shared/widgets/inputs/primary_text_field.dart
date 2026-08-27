import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A primary text input field with label, prefix/suffix icons, soft rose styling, and password toggle.
class PrimaryTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final bool autofocus;
  final bool readOnly;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final int maxLines;

  const PrimaryTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.autofocus = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.isPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E1A3C),
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 7.0),
        ],
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: isPasswordField ? _obscureText : false,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          maxLines: isPasswordField ? 1 : widget.maxLines,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E1A3C),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9E95A8),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 15.0,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Icon(
                      widget.prefixIcon,
                      color: const Color(0xFFFFA5BA),
                      size: 20.0,
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(minWidth: 46, minHeight: 46),
            suffixIcon: isPasswordField
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFFFFA5BA),
                      size: 20.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Color(0xFFEFE8F0), width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Color(0xFFEFE8F0), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Color(0xFFFF8DA1), width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: AppColors.error, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: AppColors.error, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
