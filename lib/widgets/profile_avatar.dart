import 'package:flutter/material.dart';

import '../util/theme_data.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isActive;
  final bool hasBorder;

  const ProfileAvatar({
    this.imageUrl,
    this.isActive = false,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Palette.facebookBlue,
          child: CircleAvatar(
            radius: hasBorder ? 17.0 : 20.0,
            backgroundColor: Colors.grey[200],
          ),
        ),
        isActive
            ? Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                    color: Palette.online,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
