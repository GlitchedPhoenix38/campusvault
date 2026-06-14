import 'package:flutter/material.dart';

/// A reusable search-bar widget used across all searchable selection screens.
/// Calls [onChanged] on every keystroke; [onClear] resets the field.
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: onClear,
                    )
                  : null,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          );
        },
      ),
    );
  }
}
