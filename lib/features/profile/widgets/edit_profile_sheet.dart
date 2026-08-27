import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/providers/app_scope.dart';
import '../../../shared/providers/cycle_data_controller.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Modal bottom sheet popup for editing the user profile, avatar, and cycle parameters.
class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController _nameController;
  late int _cycleLength;
  late int _periodDuration;
  late DateTime _lastPeriodDate;
  int _selectedAvatarIndex = 0;

  final List<String> _avatars = ['🌸', '🌺', '✨', '🌷', '🦋', '👑'];

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
      firstDate: DateTime.now().subtract(const Duration(days: 120)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRose,
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
        backgroundColor: Color(0xFFFF4D79),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text('🌸', style: TextStyle(fontSize: 18.0)),
                          SizedBox(width: 6.0),
                          Text(
                            'Edit Profile',
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
                        'Personalize your details and cycle settings',
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

          const SizedBox(height: 14.0),
          const Divider(height: 1.0, color: Color(0xFFEFE9F4)),

          // Scrollable Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Choose Avatar
                  const Text(
                    'Choose Avatar Symbol',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 52.0,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _avatars.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10.0),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedAvatarIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedAvatarIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFF0F5)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFF4D79)
                                    : const Color(0xFFEAE5F0),
                                width: isSelected ? 2.0 : 1.0,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: const Color(0xFFFF4D79).withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 6.0,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _avatars[index],
                                style: const TextStyle(fontSize: 22.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  // 2. Display Name Field
                  const Text(
                    'Display Name',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1A3C),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFE8E2EE),
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E1A3C),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                          color: Color(0xFF9C93A8),
                          fontSize: 14.0,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFFFF4D79),
                          size: 20.0,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18.0),

                  // 3. Average Cycle Length Stepper
                  _buildStepperRow(
                    label: 'Average Cycle Length',
                    subtitle: 'Normal range is 21–35 days',
                    value: _cycleLength,
                    unit: 'days',
                    onDecrement: _cycleLength > 21
                        ? () => setState(() => _cycleLength--)
                        : null,
                    onIncrement: _cycleLength < 45
                        ? () => setState(() => _cycleLength++)
                        : null,
                  ),

                  const SizedBox(height: 14.0),

                  // 4. Typical Period Duration Stepper
                  _buildStepperRow(
                    label: 'Typical Period Duration',
                    subtitle: 'Normal range is 3–7 days',
                    value: _periodDuration,
                    unit: 'days',
                    onDecrement: _periodDuration > 2
                        ? () => setState(() => _periodDuration--)
                        : null,
                    onIncrement: _periodDuration < 10
                        ? () => setState(() => _periodDuration++)
                        : null,
                  ),

                  const SizedBox(height: 14.0),

                  // 5. Last Period Start Date
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: const Color(0xFFE8E2EE),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last Period Start Date',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1A3C),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                '${_lastPeriodDate.day}/${_lastPeriodDate.month}/${_lastPeriodDate.year}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF4D79),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        OutlinedButton.icon(
                          onPressed: _selectLastPeriodDate,
                          icon: const Icon(
                            Icons.calendar_month_rounded,
                            size: 16.0,
                            color: Color(0xFFFF4D79),
                          ),
                          label: const Text(
                            'Change',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF4D79),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFFD1DC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 6.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  // 6. Save Button
                  PrimaryButton(
                    label: 'Save Profile Changes ✨',
                    gradient: AppGradients.dawnBloom,
                    height: 50.0,
                    onPressed: _saveChanges,
                  ),
                  const SizedBox(height: 12.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperRow({
    required String label,
    required String subtitle,
    required int value,
    required String unit,
    required VoidCallback? onDecrement,
    required VoidCallback? onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: const Color(0xFFE8E2EE),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF7A708A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Row(
            children: [
              _buildStepperButton(
                icon: Icons.remove_rounded,
                onPressed: onDecrement,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  '$value $unit',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
              ),
              _buildStepperButton(
                icon: Icons.add_rounded,
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFFFFF0F5) : const Color(0xFFF3EFF6),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isEnabled ? const Color(0xFFFFD6E2) : const Color(0xFFE5DEED),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18.0,
            color: isEnabled ? const Color(0xFFFF4D79) : const Color(0xFFAFA7BA),
          ),
        ),
      ),
    );
  }
}
