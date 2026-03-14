// Sanket: Inbox screen — refined 2026 premium chat list layout
import 'dart:async';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/screens/chat/chat_middleware.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:active_matrimonial_flutter_app/l10n/app_localizations.dart';

import '../../components/main_drawer.dart';
import '../../components/chat_list_widget.dart';
import '../../components/deactivate_Massage.dart';
import '../../components/matched_profile_widget.dart';
import '../../const/my_theme.dart';
import '../../helpers/navigator_push.dart';
import '../../redux/libs/matched_profile/matched_profile_middleware.dart';
import '../package/premium_plans.dart';

class ChatList extends StatefulWidget {
  final bool? backButtonAppearance;

  const ChatList({super.key, this.backButtonAppearance});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final PageController _matchedProfileController = PageController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initialFetch();
    _startRefreshTimer();
  }

  void _initialFetch() {
    bool isDeactivated = store.state.authState?.userData?.deactivated == 1;
    // Sanket: membership == 1 means FREE/NO PACKAGE in this system
    bool isFree = store.state.authState?.userData?.membership == 1;

    // Sanket: Approval status does NOT gate app access — any registered user can use the app.
    // Only a deactivated account is blocked.
    if (!isDeactivated && !isFree) {
      store.dispatch(Reset.chatList);
      store.dispatch(chatMiddleware());
      store.dispatch(matchedProfileFetchAction());
    } else if (isFree) {
      // If free, we MUST clear the fetching state if it was left true from a previous role/state
      // although Reset.chatList usually handles it, being explicit avoids infinite spinners.
      store.dispatch(Reset.chatList);
      // We manually set isFetching to false for free users so _buildChatList doesn't spin
      store.state.chatState?.isFetching = false;
    }
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (Timer t) {
      if (mounted && store.state.authState?.userData?.deactivated != 1) {
        store.dispatch(chatMiddleware());
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _matchedProfileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        final isDeactivated = state.authState?.userData?.deactivated == 1;
        final isFree = state.authState?.userData?.membership == 1;

        return Scaffold(
          backgroundColor: MyTheme.background,
          drawer: MainDrawer(),
          body: Column(
            children: [
              // Sanket: Fixed 56px header
              _buildHeader(context),

              Expanded(
                child:
                    isDeactivated
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: DeactivatedAccountMessage(),
                          ),
                        )
                        : (isFree
                            ? _buildFreeState(context)
                            : RefreshIndicator(
                              color: MyTheme.primary,
                              onRefresh: () async {
                                await store.dispatch(chatMiddleware());
                                await store.dispatch(matchedProfileFetchAction());
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),

                                    // Horizontal Matched Profiles
                                    MatchedProfileWidget(
                                      matched_profile_controller:
                                          _matchedProfileController,
                                      state: state,
                                    ),

                                    const SizedBox(height: 8),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.chat_list_messages,
                                        // Sanket: Section header uses Tiro Devanagari Marathi
                                        style: Styles.h2.copyWith(
                                          fontSize: 17,
                                          color: MyTheme.text_primary,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // Chat List
                                    _buildChatList(context, state),

                                    const SizedBox(height: 40),
                                  ],
                                ),
                              ),
                            )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: MyTheme.white,
        border: Border(bottom: BorderSide(color: MyTheme.border, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Left: Back or Menu
            widget.backButtonAppearance == true
                ? _headerIconBtn(
                  Icons.arrow_back_ios_new_rounded,
                  () => Navigator.pop(context),
                )
                : Builder(
                  builder:
                      (context) => _headerIconBtn(Icons.menu_rounded, () {
                        Scaffold.of(context).openDrawer();
                      }),
                ),

            const Spacer(),
            Text(
              AppLocalizations.of(context)!.profile_screen_messages,
              // Sanket: Page title uses Tiro Devanagari Marathi heading font
              style: Styles.h2.copyWith(
                fontSize: 18,
                color: MyTheme.text_primary,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),

            // Right: Notification
            _headerIconBtn(Icons.notifications_none_rounded, () {
              NavigatorPush.push(context, const Notifications());
            }),
          ],
        ),
      ),
    );
  }

  Widget _headerIconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: MyTheme.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MyTheme.border),
        ),
        child: Icon(icon, color: MyTheme.text_primary, size: 20),
      ),
    );
  }

  Widget _buildChatList(BuildContext context, AppState state) {
    if (state.chatState?.isFetching ?? true) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(color: MyTheme.primary)),
      );
    }

    final chats = state.chatState?.chatList ?? [];

    if (chats.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chats.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final chat = chats[index];
        if (chat == null) return const SizedBox.shrink();

        return ChatListWidget(
          chatId: chat.id,
          userId: chat.userId,
          name: chat.memberName,
          photo: chat.memberPhoto,
          active: chat.active,
          packageImage: chat.memberPackage?.image ?? "",
          lastMessage: chat.lastMessage,
          unseenMessageCount: chat.unseenMessageCount,
          age: chat.age?.toString(),
          isVerified: chat.approved == 1,
          phone: chat.phone,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 80, left: 40, right: 40),
        child: Column(
          children: [
            // Mock illustration with icon
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: MyTheme.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: MyTheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.chat_no_conversations,
              // Sanket: Empty state heading
              style: Styles.h2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.chat_start_connecting,
              textAlign: TextAlign.center,
              style: Styles.body.copyWith(
                fontSize: 14,
                color: MyTheme.text_secondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primary,
                foregroundColor: MyTheme.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.chat_search_button,
                style: Styles.buttonText.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreeState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: MyTheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 56,
                color: MyTheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Premium Feature",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MyTheme.text_primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Upgrade your plan to unlock messaging and connect with matches instantly.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: MyTheme.text_secondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => NavigatorPush.push(context, const PremiumPlans()),
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Upgrade Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
