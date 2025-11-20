import 'package:flutter/material.dart';

enum AvatarSize { small, medium, large }

class ProfileIcon extends StatelessWidget {
  final Image? image;
  final String userName;
  final AvatarSize size;
  final Color backgroundColor;
  final Color textColor;

  const ProfileIcon({
    super.key,
    this.image,
    required this.userName,
    this.size = AvatarSize.medium,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
  });

  double get _radius {
    switch (size) {
      case AvatarSize.small:
        return 12.0;
      case AvatarSize.medium:
        return 32.0;
      case AvatarSize.large:
        return 48.0;
    }
  }

  double get _fontSize {
    switch (size) {
      case AvatarSize.small:
        return 14.0;
      case AvatarSize.medium:
        return 18.0;
      case AvatarSize.large:
        return 40.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _radius,
      backgroundColor: backgroundColor.withOpacity(0.3),
      child: Text(
        userName.substring(0, 1),
        style: TextStyle(
          fontSize: _fontSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
