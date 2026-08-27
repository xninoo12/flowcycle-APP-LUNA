import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/app_scope.dart';
import '../../../shared/providers/cycle_data_controller.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Screen allowing the user to update their display name, avatar, and cycle parameters.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late int _cycleLength;
  late int _periodDuration;
  late DateTime _lastPeriodDate;
  int _selectedAvatarIndex = 0;

  final List<String> _avatars = ['🌸', '🌺', '✨', '🌷', '🦋'];

  @override
  void initState() {
    super.initState();
    final profile = CycleDataController.instance.userProfile;
    _nameController = TextEditingController(text: profile.name);
    _cycleLength = profile.averageCycleLength;
    _periodDuration = profile.typicalPeriodDuration;
    _lastPeriodDate = profile.lastPeriodStartDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectLastPeriodDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E1A3C),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  void _saveChanges() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    final controller = AppScope.read(context);
    controller.updateUserProfile(
      name: newName,
      averageCycleLength: _cycleLength,
      typicalPeriodDuration: _periodDuration,
      lastPeriodStartDate: _lastPeriodDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile and cycle settings updated ✨'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );

    try {
      context.pop();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F5),
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
          'Edit Profile',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1E1A3C),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Avatar Selector
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFF0F5),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 3.0,
                        ),
                        boxShadow: AppShadows.card,
                      ),
                      child: Center(
                        child: Text(
                          _avatars[_selectedAvatarIndex],
                          style: const TextStyle(fontSize: 44),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_avatars.length, (index) {
                        final isSelected = _selectedAvatarIndex == index;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedAvatarIndex = index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFFFFF0F5)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFFEDE8E0),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              _avatars[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Personal Information Card
              Text(
                'PERSONAL INFORMATION',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7A708A),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: const Color(0xFFEFE9F3)),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1A3C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1A3C),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        filled: true,
                        fillColor: const Color(0xFFFAF7F5),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEDE8E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEDE8E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Cycle Baselines Card
              Text(
                'CYCLE BASELINES',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7A708A),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: const Color(0xFFEFE9F3)),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    // Cycle Length Stepper
                    _buildStepperRow(
                      title: 'Average Cycle Length',
                      subtitle: 'Typical interval between periods',
                      value: '$_cycleLength days',
                      canDecrement: _cycleLength > 21,
                      canIncrement: _cycleLength < 45,
                      onDecrement: () => setState(() => _cycleLength--),
                      onIncrement: () => setState(() => _cycleLength++),
                    ),
                    const Divider(height: 24, color: Color(0xFFEFE9F3)),

                    // Period Duration Stepper
                    _buildStepperRow(
                      title: 'Period Duration',
                      subtitle: 'Typical number of bleeding days',
                      value: '$_periodDuration days',
                      canDecrement: _periodDuration > 2,
                      canIncrement: _periodDuration < 10,
                      onDecrement: () => setState(() => _periodDuration--),
                      onIncrement: () => setState(() => _periodDuration++),
                    ),
                    const Divider(height: 24, color: Color(0xFFEFE9F3)),

                    // Last Period Date Picker Tile
                    InkWell(
                      onTap: _selectLastPeriodDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Period Start Date',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E1A3C),
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  Text(
                                    '${_lastPeriodDate.month}/${_lastPeriodDate.day}/${_lastPeriodDate.year}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF7A708A),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. Save Button
              PrimaryButton(label: 'Save Changes', onPressed: _saveChanges),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildStepperRow({
    required String title,
    required String subtitle,
    required String value,
    required bool canDecrement,
    required bool canIncrement,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1A3C),
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF7A708A),
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepperButton(
              icon: Icons.remove_rounded,
              enabled: canDecrement,
              onTap: onDecrement,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 70),
              child: Center(
                child: Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1A3C),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            _buildStepperButton(
              icon: Icons.add_rounded,
              enabled: canIncrement,
              onTap: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFFAF7F5) : const Color(0xFFF3EFE9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled
                  ? const Color(0xFFEDE8E0)
                  : const Color(0xFFE5DFD7),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: enabled ? const Color(0xFF1E1A3C) : const Color(0xFFAAA3B8),
          ),
        ),
      ),
    );
  }
}
