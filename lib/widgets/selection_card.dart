import 'package:flutter/material.dart';

/// A generic, reusable selection card used across all hierarchy screens
/// (university, college, course, year).
///
/// Parameters:
/// - [title]       Primary label shown in bold.
/// - [subtitle]    Secondary label shown below title (optional).
/// - [accentColor] Tint used for the avatar background and icon.
/// - [avatarLabel] Short text (≤ 3 chars) shown inside the colored avatar box.
/// - [avatarIcon]  Icon shown instead of text when [avatarLabel] is null.
/// - [onTap]       Callback when the card is pressed.
/// - [trailing]    Optional widget placed at the far right (defaults to chevron).
class SelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color accentColor;
  final String? avatarLabel;
  final IconData? avatarIcon;
  final VoidCallback onTap;
  final Widget? trailing;

  const SelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.accentColor,
    this.avatarLabel,
    this.avatarIcon,
    required this.onTap,
    this.trailing,
  }) : assert(
          avatarLabel != null || avatarIcon != null,
          'Provide either avatarLabel or avatarIcon',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      color: theme.colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: accentColor.withValues(alpha: 0.08),
        highlightColor: accentColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // ── Avatar ──────────────────────────────────────────────────
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: avatarLabel != null
                      ? Text(
                          avatarLabel!.length > 3
                              ? avatarLabel!.substring(0, 3)
                              : avatarLabel!,
                          style: TextStyle(
                            color: accentColor,
                            fontSize: avatarLabel!.length > 2 ? 14 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(avatarIcon, color: accentColor, size: 26),
                ),
              ),
              const SizedBox(width: 16),

              // ── Content ─────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),
              // ── Trailing ────────────────────────────────────────────────
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
