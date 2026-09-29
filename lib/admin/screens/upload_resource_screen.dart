import 'package:flutter/material.dart';
import 'package:campusvault/admin/widgets/hierarchy_selector.dart';
import 'package:campusvault/admin/widgets/resource_type_chip.dart';
import 'package:campusvault/models/admin_user.dart';
import 'package:campusvault/models/resource.dart';

class UploadResourceScreen extends StatefulWidget {
  final AdminUser admin;

  const UploadResourceScreen({super.key, required this.admin});

  @override
  State<UploadResourceScreen> createState() => _UploadResourceScreenState();
}

class _UploadResourceScreenState extends State<UploadResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();

  ResourceType _selectedType = ResourceType.pdf;
  HierarchySelection _selection = const HierarchySelection();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_selection.isComplete) {
      _showSnack('Please complete the full hierarchy selection.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    // Simulate upload delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _showSnack('Resource uploaded successfully! (Mock)');
    Navigator.of(context).pop();
  }

  void _showSnack(String msg, {bool isError = false}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isError ? theme.colorScheme.error : const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Resource'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Section: Resource Details ─────────────────────────────
              _SectionHeader(
                  icon: Icons.edit_note_rounded, label: 'Resource Details'),
              const SizedBox(height: 14),

              // Title
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: _inputDeco(theme,
                    label: 'Title', hint: 'e.g. Calculus Notes Unit 1'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                textInputAction: TextInputAction.next,
                decoration: _inputDeco(theme,
                    label: 'Description',
                    hint: 'Brief description of this resource…'),
              ),
              const SizedBox(height: 24),

              // ── Section: Resource Type ────────────────────────────────
              _SectionHeader(
                  icon: Icons.category_rounded, label: 'Resource Type'),
              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ResourceType.values
                    .map((type) => ResourceTypeChip(
                          type: type,
                          selected: _selectedType == type,
                          onTap: () =>
                              setState(() => _selectedType = type),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 14),

              // URL / Link field (shown for externalLink and conditionally for others)
              if (_selectedType == ResourceType.externalLink)
                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDeco(theme,
                      label: 'External URL',
                      hint: 'https://example.com/resource'),
                  validator: (v) {
                    if (_selectedType == ResourceType.externalLink &&
                        (v == null || v.trim().isEmpty)) {
                      return 'URL is required for external links';
                    }
                    return null;
                  },
                ),

              // File picker placeholder (PDF / Image)
              if (_selectedType != ResourceType.externalLink)
                _FilePicker(type: _selectedType),

              const SizedBox(height: 24),

              // ── Section: Hierarchy Target ─────────────────────────────
              _SectionHeader(
                  icon: Icons.account_tree_rounded, label: 'Target Location'),
              const SizedBox(height: 4),
              Text(
                'Select where this resource should appear in the app.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),

              HierarchySelector(
                onSelectionChanged: (s) => setState(() => _selection = s),
              ),

              const SizedBox(height: 32),

              // ── Submit ────────────────────────────────────────────────
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isSubmitting ? null : _onSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.cloud_upload_rounded, size: 20),
                  label: Text(_isSubmitting ? 'Uploading…' : 'Upload Resource'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(ThemeData theme,
      {required String label, required String hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

// ── Section header row ────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// ── File picker placeholder ───────────────────────────────────────────────────
class _FilePicker extends StatelessWidget {
  final ResourceType type;
  const _FilePicker({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPdf = type == ResourceType.pdf;
    final color = type.color;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'File picker will use file_picker package when Firebase Storage is integrated.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isPdf
                  ? Icons.picture_as_pdf_rounded
                  : Icons.add_photo_alternate_rounded,
              size: 40,
              color: color.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap to select ${isPdf ? 'PDF' : 'Image'}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isPdf
                  ? 'Max 20 MB • .pdf files only'
                  : 'Max 5 MB • JPG, PNG, WebP',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
