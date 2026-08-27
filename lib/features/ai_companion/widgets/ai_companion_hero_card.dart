import 'package:flutter/material.dart';

/// Open-Space Hero Section for AI Companion Hub.
///
/// Features greeting, journey description, "Chat with me ✨" pill CTA,
/// and the floating 3D companion mascot sitting directly in canvas space.
class AiCompanionHeroCard extends StatelessWidget {
  final String userName;
  final String description;
  final VoidCallback? onChatTap;

  const AiCompanionHeroCard({
    super.key,
    this.userName = 'Amina',
    this.description =
        "I'm here to support your journey to baby. Ask me anything or explore personalized insights just for you.",
    this.onChatTap,
  });

  String _cleanUserName(String name) {
    if (name.isEmpty) return 'Amina';
    return name.split('(').first.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cleanName = _cleanUserName(userName);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Left Text Column & "Chat with me ✨" CTA
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Greeting: "Hi Amina 👋"
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Hi $cleanName',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E1A3C),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  const Text('👋', style: TextStyle(fontSize: 18.0)),
                ],
              ),

              const SizedBox(height: 6.0),

              // Description
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6E6875),
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 12.0),

              // "Chat with me ✨" Gradient Pill Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onChatTap,
                  borderRadius: BorderRadius.circular(24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 9.5,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                          blurRadius: 10.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Chat with me',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text('✨', style: TextStyle(fontSize: 12.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8.0),

        // 2. Right: 3D Floating Mascot Character with Aura, Heart & Sparkles
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 135.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft background radial aura
                Container(
                  width: 112.0,
                  height: 112.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFEDE9FE).withValues(alpha: 0.9),
                        const Color(0xFFEDE9FE).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),

                // Mascot Sphere Body
                Container(
                  width: 88.0,
                  height: 88.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEFE8FD), Color(0xFFDCD2F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                        blurRadius: 16.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Eyes & Smile
                      Positioned(
                        top: 32.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Left Eye
                            Container(
                              width: 5.5,
                              height: 5.5,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E1A3C),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 22.0),
                            // Right Eye
                            Container(
                              width: 5.5,
                              height: 5.5,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E1A3C),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Gentle Smile Curve
                      Positioned(
                        top: 42.0,
                        child: Container(
                          width: 8.0,
                          height: 4.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF1E1A3C),
                                width: 1.5,
                              ),
                            ),
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(4.0),
                            ),
                          ),
                        ),
                      ),

                      // Pink Heart Mouth Badge
                      Positioned(
                        bottom: 12.0,
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B8B), Color(0xFFFF4D6D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF4D6D).withValues(alpha: 0.4),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 13.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating Sparkle 1 (Top Right)
                const Positioned(
                  top: 14.0,
                  right: 10.0,
                  child: Text(
                    '✦',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFFF85A1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Floating Sparkle 2 (Bottom Left)
                const Positioned(
                  bottom: 16.0,
                  left: 10.0,
                  child: Text(
                    '✦',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: Color(0xFFFF85A1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Floating Leaf Petal 1 (Bottom Left)
                const Positioned(
                  bottom: 24.0,
                  left: 2.0,
                  child: Text('🌸', style: TextStyle(fontSize: 11.0)),
                ),

                // Floating Leaf Petal 2 (Bottom Right)
                const Positioned(
                  bottom: 24.0,
                  right: 2.0,
                  child: Text('🍃', style: TextStyle(fontSize: 11.0)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
