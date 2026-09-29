import 'package:flutter/material.dart';
import 'package:campusvault/data/academic_data.dart';
import 'package:campusvault/data/subject_data.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/academic_year.dart';
import 'package:campusvault/models/subject.dart';
import 'package:campusvault/models/university.dart';

/// Fully self-contained cascading hierarchy selector.
/// Used on the Dashboard (filter) and Upload Resource screen (target selection).
///
/// Each dropdown resets all deeper dropdowns when its value changes.
/// Calls [onSelectionChanged] whenever any value changes, passing the
/// current state — null means that level has not been selected yet.
class HierarchySelector extends StatefulWidget {
  final void Function(HierarchySelection selection) onSelectionChanged;

  /// Pre-populate from an existing selection (optional).
  final HierarchySelection? initialSelection;

  const HierarchySelector({
    super.key,
    required this.onSelectionChanged,
    this.initialSelection,
  });

  @override
  State<HierarchySelector> createState() => _HierarchySelectorState();
}

class _HierarchySelectorState extends State<HierarchySelector> {
  University? _university;
  College? _college;
  AcademicYear? _year;
  Subject? _subject;

  List<College> get _colleges =>
      _university != null ? getCollegesForUniversity(_university!.id) : [];

  List<Course> get _programs =>
      _college != null
          ? courses.where((c) => c.collegeId == _college!.id).toList()
          : [];

  List<AcademicYear> get _years =>
      _course != null ? getYearsForProgram(_course!.programType) : [];

  // Need to track selected course as "program"
  Course? _course;

  List<Subject> get _subjects {
    if (_course == null || _year == null) return [];
    return getSubjectsForYear(
          courseId: _course!.id,
          yearId: _year!.id,
        ) ??
        [];
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      final s = widget.initialSelection!;
      _university = s.university;
      _college = s.college;
      _course = s.course;
      _year = s.year;
      _subject = s.subject;
    }
  }

  void _notify() {
    widget.onSelectionChanged(HierarchySelection(
      university: _university,
      college: _college,
      programType: _course?.programType,
      course: _course,
      year: _year,
      subject: _subject,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. University
        _DropdownRow<University>(
          label: 'University',
          icon: Icons.account_balance_rounded,
          value: _university,
          items: universities,
          itemLabel: (u) => u.name,
          onChanged: (u) {
            setState(() {
              _university = u;
              _college = null;
              _course = null;
              _year = null;
              _subject = null;
            });
            _notify();
          },
        ),
        const SizedBox(height: 12),

        // 2. College
        _DropdownRow<College>(
          label: 'College',
          icon: Icons.school_rounded,
          value: _college,
          items: _colleges,
          itemLabel: (c) => c.name,
          enabled: _university != null,
          onChanged: (c) {
            setState(() {
              _college = c;
              _course = null;
              _year = null;
              _subject = null;
            });
            _notify();
          },
        ),
        const SizedBox(height: 12),

        // 3. Program (Combined ProgramType + Course)
        _DropdownRow<Course>(
          label: 'Program',
          icon: Icons.layers_rounded,
          value: _course,
          items: _programs,
          itemLabel: (c) => '${c.programType.code} — ${c.name}',
          enabled: _college != null,
          onChanged: (c) {
            setState(() {
              _course = c;
              _year = null;
              _subject = null;
            });
            _notify();
          },
        ),
        const SizedBox(height: 12),

        // 4. Year
        _DropdownRow<AcademicYear>(
          label: 'Year',
          icon: Icons.calendar_today_rounded,
          value: _year,
          items: _years,
          itemLabel: (y) => y.label,
          enabled: _course != null,
          onChanged: (y) {
            setState(() {
              _year = y;
              _subject = null;
            });
            _notify();
          },
        ),
        const SizedBox(height: 12),

        // 5. Subject
        _DropdownRow<Subject>(
          label: 'Subject',
          icon: Icons.auto_stories_rounded,
          value: _subject,
          items: _subjects,
          itemLabel: (s) => '${s.code} — ${s.name}',
          enabled: _year != null,
          onChanged: (s) {
            setState(() => _subject = s);
            _notify();
          },
        ),
      ],
    );
  }
}

// ── Generic dropdown row ──────────────────────────────────────────────────────
class _DropdownRow<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final bool enabled;

  const _DropdownRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveValue = items.contains(value) ? value : null;

    return DropdownButtonFormField<T>(
      initialValue: effectiveValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: 20,
          color: enabled
              ? theme.colorScheme.primary.withValues(alpha: 0.7)
              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.4),
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
          borderSide:
              BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      hint: Text(
        enabled ? 'Select $label' : 'Select previous first',
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          fontSize: 14,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ))
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}

// ── Data class carrying the current hierarchy state ───────────────────────────
class HierarchySelection {
  final University? university;
  final College? college;
  final ProgramType? programType;
  final Course? course;
  final AcademicYear? year;
  final Subject? subject;

  const HierarchySelection({
    this.university,
    this.college,
    this.programType,
    this.course,
    this.year,
    this.subject,
  });

  bool get isComplete =>
      university != null &&
      college != null &&
      programType != null &&
      course != null &&
      year != null &&
      subject != null;
}
