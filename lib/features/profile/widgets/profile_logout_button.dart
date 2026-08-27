import 'package:flutter/material.dart';

/// Pink outlined Log out button matching exact UI specifications.
class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onLogout;

  const ProfileLogoutButton({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onLogout,
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          width: double.infinity,
          height: 44.0,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFFFCCD8), width: 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.logout_rounded, color: Color(0xFFE84D75), size: 16.0),
              SizedBox(width: 6.0),
              Text(
                'Log out',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE84D75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
