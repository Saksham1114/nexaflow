import 'package:flutter/material.dart';

import '../../models/user_profile.dart';

class AchievementBadgeCard extends StatelessWidget {
  const AchievementBadgeCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badges = profile.badges;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Achievements",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${profile.unlockedBadgeCount}/${badges.length} Unlocked",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: badges.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final badge = badges[index];

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? theme.cardColor
                    : theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: badge.isUnlocked
                      ? badge.color.withAlpha(60)
                      : theme.dividerColor.withAlpha(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: badge.isUnlocked
                          ? badge.color.withAlpha(30)
                          : theme.disabledColor.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      badge.icon,
                      color: badge.isUnlocked ? badge.color : theme.disabledColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              badge.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: badge.isUnlocked
                                    ? theme.colorScheme.onSurface
                                    : theme.disabledColor,
                              ),
                            ),
                            if (badge.isUnlocked) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: Colors.green,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          badge.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.hintColor,
                          ),
                        ),
                        if (!badge.isUnlocked) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: badge.progressPercentage,
                              minHeight: 4,
                              backgroundColor:
                                  theme.dividerColor.withAlpha(40),
                              valueColor: AlwaysStoppedAnimation(badge.color),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
