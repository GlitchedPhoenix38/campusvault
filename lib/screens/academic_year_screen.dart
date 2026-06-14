import 'package:flutter/material.dart';
import 'package:campusvault/data/academic_data.dart';
import 'package:campusvault/models/academic_year.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/utils/route_transitions.dart';
import 'package:campusvault/widgets/breadcrumb_bar.dart';
import 'package:campusvault/widgets/selection_card.dart';

class AcademicYearScreen extends StatelessWidget {
  final University university;
  final College college;
  final ProgramType programType;
  final Course course;

  const AcademicYearScreen({
    super.key,
    required this.university,
    required this.college,
    required this.programType,
    required this.course,
  });

  void _onYearTapped(BuildContext context, AcademicYear year) {
    Navigator.of(context).push(
      slideRoute(
        _YearPlaceholderScreen(
          university: university,
          college: college,
          programType: programType,
          course: course,
          year: year,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final years = getYearsForProgram(programType);

    // Colours per year ordinal
    const yearColors = [
      Color(0xFF4F46E5),
      Color(0xFF0D9488),
      Color(0xFFF59E0B),
      Color(0xFFEF4444),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Year'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreadcrumbBar(
              crumbs: [
                university.shortName,
                college.shortName,
                programType.code,
                'Year',
              ],
            ),
            // Course context chip
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _CourseContextChip(course: course),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  final color = yearColors[index % yearColors.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SelectionCard(
                      title: year.label,
                      subtitle: 'Year ${year.yearNumber} of ${years.length}',
                      accentColor: color,
                      avatarLabel: '${year.yearNumber}',
                      onTap: () => _onYearTapped(context, year),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small chip showing which course was selected ─────────────────────────────
class _CourseContextChip extends StatelessWidget {
  final Course course;
  const _CourseContextChip({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.book_outlined,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              course.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Placeholder screen shown after year selection ─────────────────────────────
class _YearPlaceholderScreen extends StatelessWidget {
  final University university;
  final College college;
  final ProgramType programType;
  final Course course;
  final AcademicYear year;

  const _YearPlaceholderScreen({
    required this.university,
    required this.college,
    required this.programType,
    required this.course,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(year.label),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreadcrumbBar(
              crumbs: [
                university.shortName,
                college.shortName,
                programType.code,
                year.label,
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Selection Summary Card ──────────────────────────
                    _SummaryCard(
                      university: university,
                      college: college,
                      programType: programType,
                      course: course,
                      year: year,
                    ),
                    const SizedBox(height: 28),
                    // ── Coming Soon section ─────────────────────────────
                    Text(
                      'Resources',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ComingSoonGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary card listing selected context ─────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final University university;
  final College college;
  final ProgramType programType;
  final Course course;
  final AcademicYear year;

  const _SummaryCard({
    required this.university,
    required this.college,
    required this.programType,
    required this.course,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Your Selection',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),
          _SummaryRow(label: 'University', value: university.name),
          const SizedBox(height: 8),
          _SummaryRow(label: 'College', value: college.name),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Program', value: programType.label),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Course', value: course.name),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Year', value: year.label),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Placeholder resource tiles (coming soon) ──────────────────────────────────
class _ComingSoonGrid extends StatelessWidget {
  final List<_ResourceItem> _resources = const [
    _ResourceItem(Icons.description_outlined, 'Notes', Color(0xFF4F46E5)),
    _ResourceItem(Icons.quiz_outlined, 'PYQs', Color(0xFF0D9488)),
    _ResourceItem(Icons.list_alt_outlined, 'Syllabus', Color(0xFFF59E0B)),
    _ResourceItem(Icons.link_rounded, 'Resources', Color(0xFFD946EF)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _resources.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final item = _resources[index];
        return Container(
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: item.color, size: 32),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Coming soon',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResourceItem {
  final IconData icon;
  final String label;
  final Color color;
  const _ResourceItem(this.icon, this.label, this.color);
}
