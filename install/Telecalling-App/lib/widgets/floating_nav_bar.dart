import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'glass_container.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: GlassContainer(
        borderRadius: 30,
        opacity: 0.15,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_rounded, 'Home', context),
            _navItem(1, Icons.group_rounded, 'Leads', context),
            _navItem(2, Icons.schedule_rounded, 'Events', context),
            _navItem(3, Icons.folder_shared_rounded, 'CRM', context),
            _navItem(4, Icons.person_rounded, 'Profile', context),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, BuildContext context) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: AppConfig.fast,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary(context).withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary(context) : AppColors.textSecondary(context),
              size: 26,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
            )
        ],
      ),
    );
  }
}
// Sanket
