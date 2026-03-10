// Sanket: Chat item card for Inbox screen — premium 2026 layout
import 'package:flutter/material.dart';
import '../const/my_theme.dart';
import '../const/style.dart';
import '../screens/chat/chat.dart';
import 'my_images.dart';

class ChatListWidget extends StatelessWidget {
  final int chatId;
  final int userId;
  final String name;
  final String photo;
  final String packageImage;
  final int active;
  final String? lastMessage;
  final int unseenMessageCount;
  final String? age;
  final bool? isVerified;
  final String? phone;

  const ChatListWidget({
    super.key,
    required this.chatId,
    required this.userId,
    required this.name,
    required this.photo,
    required this.active,
    required this.packageImage,
    required this.lastMessage,
    required this.unseenMessageCount,
    this.age,
    this.isVerified,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    // Sanket: Mock compatibility score for premium 2026 feel
    final String compatibility = "${75 + (userId % 20)}% Match";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => Chat(
                  chatId: chatId,
                  userId: userId,
                  name: name,
                  picture: photo,
                  age: age,
                  isVerified: isVerified,
                  phone: phone,
                ),
          ),
        );
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: Profile Image (52px) with 16px radius
            Stack(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: MyTheme.background,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: MyImages.normalImage(photo),
                  ),
                ),
                // Online indicator
                if (active == 1)
                  Positioned(
                    right: -1,
                    bottom: -1,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: MyTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: MyTheme.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Middle: Name, Last message, Compatibility
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.profileName.copyWith(
                            // Sanket: Chat name uses Mukta SemiBold per typography system
                            fontSize: 15,
                            color: MyTheme.text_primary,
                          ),
                        ),
                      ),
                      if (isVerified == true) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 14,
                        ),
                      ],
                      const SizedBox(width: 8),
                      // Compatibility Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: MyTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          compatibility,
                          style: TextStyle(
                            color: MyTheme.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastMessage ?? "संवाद सुरू करा...",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.caption.copyWith(
                      fontSize: 13,
                      color: MyTheme.text_secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Time and Unread Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "2m ago",
                  style: Styles.caption.copyWith(
                    fontSize: 11,
                    color: MyTheme.text_secondary,
                  ),
                ),
                const SizedBox(height: 4),
                if (unseenMessageCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: const BoxDecoration(
                      color: MyTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        unseenMessageCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
