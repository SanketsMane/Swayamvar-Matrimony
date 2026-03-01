// Sanket: Chat room screen — premium 2026 layout
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:active_matrimonial_flutter_app/components/my_images.dart';
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/aiz_route.dart';
import 'package:active_matrimonial_flutter_app/helpers/device_info.dart';
import 'package:active_matrimonial_flutter_app/middleware/profile_view_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_reply_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/user_pages/user_public_profile.dart';
import 'package:flutter/material.dart';

import '../../models_response/chat/chat_details_response.dart';
import 'chat_details_middleware.dart';

class Chat extends StatefulWidget {
  final int? chatId;
  final int userId;
  final dynamic name;
  final dynamic picture;

  const Chat({
    this.chatId,
    required this.userId,
    super.key,
    this.name,
    this.picture,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        // Sanket: Proactively show a preview or send immediately? 
        // For now, let's send it immediately to keep the flow fast.
        _sendReply(attachment: _selectedImage);
        setState(() {
          _selectedImage = null;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _sendReply({String? text, File? attachment}) {
    store.dispatch(
      chatReplyMiddleware(
        id: widget.chatId,
        text: text ?? _msgController.text,
        attachment: attachment,
      ),
    );
    _msgController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    
    // Optimistic refresh
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        store.dispatch(chatDetailsMiddleware(chatId: widget.chatId));
      }
    });
  }

  void _fetchAll() {
    store.dispatch(Reset.chatDetailsList);
    store.dispatch(chatDetailsMiddleware(chatId: widget.chatId));
  }

  @override
  void initState() {
    super.initState();
    _myId = store.state.authState?.userData?.id;
    _fetchAll();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        store.dispatch(chatDetailsMiddleware(chatId: widget.chatId));
      }
    });
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        final String compatibility = "${75 + (widget.userId % 20)}% Match";

        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: _buildHeader(context, compatibility),
          body:
              state.chatDetailsState!.isFetching!
                  ? const Center(
                    child: CircularProgressIndicator(color: MyTheme.primary),
                  )
                  : Column(
                    children: [
                      // Sanket: Premium Match Info Card
                      _buildMatchInfoCard(),

                      Expanded(child: _buildMessageArea(state)),

                      // Sanket: Sticky bottom message input
                      _buildMessageInput(context),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildMatchInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _infoBadge(Icons.verified, "पडताळणी केलेले", Colors.blue),
          const SizedBox(width: 20),
          _infoBadge(Icons.favorite, "गंभीर जोडी", MyTheme.primary),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: Styles.caption.copyWith(
            fontSize: 11,
            color: MyTheme.text_primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageArea(AppState state) {
    final messages = state.chatDetailsState?.chatDetailsList?.messages ?? [];

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: MyTheme.text_secondary.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              "संवाद सुरू करा",
              style: Styles.body.copyWith(
                fontSize: 14,
                color: MyTheme.text_secondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final msg = messages[index];
        bool isMe = msg.senderUserId == _myId;

        return _buildMessageBubble(msg, isMe);
      },
    );
  }

  Widget _buildMessageBubble(Message msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? MyTheme.primary : MyTheme.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child:
                (msg.attachment?.isEmpty ?? true)
                    ? Text(
                      msg.message ?? '',
                      style: Styles.body.copyWith(
                        color: isMe ? Colors.white : MyTheme.text_primary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.message != null && msg.message!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              msg.message!,
                              style: Styles.body.copyWith(
                                color: isMe ? Colors.white : MyTheme.text_primary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        _buildAttachments(msg),
                      ],
                    ),
          ),
          const SizedBox(height: 4),
          Text(
            "आत्ता", // Sanket: "Just now" in Marathi
            style: Styles.regular_gull_grey_12.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: MyTheme.white,
        border: Border(top: BorderSide(color: MyTheme.border, width: 1)),
      ),
      child: Row(
        children: [
          // Attachment icon
          _inputIconButton(Icons.add_circle_outline_rounded, _pickImage),
          const SizedBox(width: 8),

          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: MyTheme.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: MyTheme.border),
              ),
              child: TextField(
                controller: _msgController,
                style: const TextStyle(fontSize: 14),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    _sendReply();
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'आपला संदेश टाइप करा...',
                  hintStyle: Styles.body.copyWith(
                    color: MyTheme.text_secondary,
                    fontSize: 13,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: () {
              if (_msgController.text.trim().isNotEmpty) {
                _sendReply();
              }
            },
            child: Container(
              height: 44,
              width: 44,
              decoration: const BoxDecoration(
                color: MyTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: MyTheme.text_secondary, size: 28),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context, String compatibility) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      toolbarHeight: 64,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: MyTheme.text_primary,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      centerTitle: false,
      title: InkWell(
        onTap: () {
          AIZRoute.push(
            context,
            UserPublicProfile(userId: widget.userId),
            middleware: ProfileViewMiddleware(
              context: context,
              user: store.state.authState?.userData,
            ),
          );
        },
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MyTheme.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: MyImages.normalImage(widget.picture),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 10,
                    width: 10,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.name} | 28",
                  // Sanket: Profile name uses Mukta SemiBold per typography system
                  style: Styles.profileName.copyWith(
                    fontSize: 16,
                    color: MyTheme.text_primary,
                  ),
                ),
                Text(
                  compatibility,
                  style: Styles.caption.copyWith(
                    color: MyTheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        _headerIcon(Icons.call_rounded, () {}),
        _headerIcon(Icons.more_vert_rounded, () {}),
        const SizedBox(width: 8),
      ],
      shape: const Border(bottom: BorderSide(color: MyTheme.border, width: 1)),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: MyTheme.text_primary, size: 22),
      onPressed: onTap,
    );
  }

  Widget _buildAttachments(Message msg) {
    return Wrap(
      spacing: 4,
      runSpacing: 10,
      children: List.generate(
        msg.attachment?.length ?? 0,
        (index) => _attachmentItem(msg.attachment![index]),
      ),
    );
  }

  Widget _attachmentItem(Attachment attachment) {
    if (attachment.attachmentType == "image") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 200,
          child: MyImages.normalImage(attachment.attachment),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.insert_drive_file_rounded,
            size: 30,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.fileName ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  ".${attachment.extension ?? ''}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
