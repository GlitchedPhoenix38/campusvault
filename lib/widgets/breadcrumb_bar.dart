import 'package:flutter/material.dart';

/// A breadcrumb bar that shows the user's current location in the hierarchy.
/// Accepts a list of [crumbs] in order (e.g., ['MGM', 'JNEC', 'UG', 'CSE']).
/// The last crumb is highlighted as the active level.
class BreadcrumbBar extends StatelessWidget {
  final List<String> crumbs;

  const BreadcrumbBar({super.key, required this.crumbs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.45);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 2,
        children: [
          for (int i = 0; i < crumbs.length; i++) ...[
            Text(
              crumbs[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: i == crumbs.length - 1 ? FontWeight.w600 : FontWeight.normal,
                color: i == crumbs.length - 1 ? primary : muted,
              ),
            ),
            if (i < crumbs.length - 1)
              Icon(Icons.chevron_right_rounded, size: 14, color: muted),
          ],
        ],
      ),
    );
  }
}
