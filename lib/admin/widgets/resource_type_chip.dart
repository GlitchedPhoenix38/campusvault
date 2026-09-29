import 'package:flutter/material.dart';
import 'package:campusvault/models/resource.dart';

/// A selectable chip representing a [ResourceType].
/// Highlights when [selected] and calls [onTap] when pressed.
class ResourceTypeChip extends StatelessWidget {
  final ResourceType type;
  final bool selected;
  final VoidCallback onTap;

  const ResourceTypeChip({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = type.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.6)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              size: 18,
              color: selected
                  ? color
                  : theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 7),
            Text(
              type.label,
              style: TextStyle(
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
                color: selected
                    ? color
                    : theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
