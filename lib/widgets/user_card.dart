import 'package:flutter/material.dart';
import 'package:login/widgets/profile_avatar.dart';

import '../models/user_provider.dart';

class UserCard extends StatelessWidget {
  final UserProvider? user;

  const UserCard({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(imageUrl: user?.imageUrl),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              'user.name',
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
