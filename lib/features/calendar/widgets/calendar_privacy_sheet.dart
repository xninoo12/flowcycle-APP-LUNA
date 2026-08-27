import 'package:flutter/material.dart';

/// Modal bottom sheet detailing reproductive privacy, on-device encryption and PIN protection.
class CalendarPrivacySheet extends StatelessWidget {
  final VoidCallback? onConfigurePin;

  const CalendarPrivacySheet({
    super.key,
    this.onConfigurePin,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 44.0,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2DCE8),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // 2. Title & Shield Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Reproductive Privacy Guarantee',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1A3C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          'Your intimate cycle records never leave your phone',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7A708A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE9FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFF7C3AED),
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),

              // 3. 3 Core Privacy Pillars
              _buildPillarTile(
                icon: Icons.lock_outline_rounded,
                title: 'Private Intimacy Mode (💜🔒)',
                description:
                    'Days with sexual intercourse or sensitive notes are masked with a discreet locked badge and can be hidden entirely from calendar previews.',
              ),

              const SizedBox(height: 12.0),

              _buildPillarTile(
                icon: Icons.phonelink_lock_rounded,
                title: 'On-Device Zero Knowledge',
                description:
                    'All cycle calculations, LH tests, and BBT logs are processed locally using encrypted on-device storage with zero tracking or ad identifiers.',
              ),

              const SizedBox(height: 12.0),

              _buildPillarTile(
                icon: Icons.fingerprint_rounded,
                title: 'Biometric & PIN App Lock',
                description:
                    'Require Face ID, fingerprint, or 4-digit PIN every time FlowCycle is opened or brought back to the foreground.',
              ),

              const SizedBox(height: 20.0),

              // 4. Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfigurePin?.call();
                  },
                  icon: const Icon(
                    Icons.security_rounded,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  label: const Text(
                    'Configure PIN & Privacy Settings',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillarTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7FC),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFF1ECF5),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.0,
            height: 34.0,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Icon(icon, color: const Color(0xFF7C3AED), size: 18.0),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E1A3C),
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A708A),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
