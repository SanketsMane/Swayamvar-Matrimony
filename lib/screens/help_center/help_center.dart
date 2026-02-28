// Sanket: New Help Center Hub — premium 2026 design system
import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:active_matrimonial_flutter_app/const/style.dart';
import 'package:active_matrimonial_flutter_app/helpers/navigator_push.dart';
import 'package:active_matrimonial_flutter_app/screens/core.dart';
import 'package:active_matrimonial_flutter_app/screens/support_ticket/support_ticket.dart';
import 'package:active_matrimonial_flutter_app/screens/contact_us/contact_us.dart';
import 'package:flutter/material.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How to send interest?',
      'answer':
          'Go to the member\'s profile and tap on the "Send Interest" heart icon. Once they accept, you can start communicating.',
      'isExpanded': false,
    },
    {
      'question': 'How to upgrade membership?',
      'answer':
          'Navigate to Settings > Membership Plan or visit the "Packages" section to view and select a premium plan that suits your needs.',
      'isExpanded': false,
    },
    {
      'question': 'How to verify profile?',
      'answer':
          'Go to Settings > Verification Status. Upload your ID proof (Aadhaar/PAN/Passport) and a selfie for our team to review.',
      'isExpanded': false,
    },
    {
      'question': 'How to change password?',
      'answer':
          'Visit Settings > Security > Change Password. Enter your current password followed by your new password twice to confirm.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.background,
      appBar: _buildHeader(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildQuickHelpGrid(context),
            const SizedBox(height: 32),
            _buildFAQSection(),
            const SizedBox(height: 32),
            _buildContactSupportCard(context),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: MyTheme.text_primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Help Center",
        style: TextStyle(
          color: MyTheme.text_primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: MyTheme.border, height: 1),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: MyTheme.solitude,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search help topics…",
          hintStyle: TextStyle(color: MyTheme.text_secondary, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: MyTheme.text_secondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildQuickHelpGrid(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'title': 'Account Help', 'icon': Icons.person_outline_rounded},
      {'title': 'Membership Help', 'icon': Icons.card_membership_rounded},
      {'title': 'Verification Help', 'icon': Icons.verified_user_outlined},
      {'title': 'Technical Help', 'icon': Icons.settings_suggest_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: MyTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                items[index]['icon'] as IconData,
                color: MyTheme.primary,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                items[index]['title'] as String,
                style: const TextStyle(
                  color: MyTheme.text_primary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Frequently Asked Questions",
          style: TextStyle(
            color: MyTheme.text_primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_faqs.length, (index) {
          final faq = _faqs[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  faq['question'],
                  style: const TextStyle(
                    color: MyTheme.text_primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  faq['isExpanded']
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: MyTheme.text_secondary,
                ),
                onExpansionChanged: (expanded) {
                  setState(() {
                    faq['isExpanded'] = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer'],
                      style: const TextStyle(
                        color: MyTheme.text_secondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildContactSupportCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Still need help?",
            style: TextStyle(
              color: MyTheme.text_primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Our support team is ready to help you with any queries or issues.",
            style: TextStyle(color: MyTheme.text_secondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => NavigatorPush.push(context, const SupportTicket()),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.primary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Contact Support",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "support@swayamvar.in",
              style: TextStyle(
                color: MyTheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
