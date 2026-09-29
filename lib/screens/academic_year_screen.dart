import 'package:flutter/material.dart';
import 'package:campusvault/data/academic_data.dart';
import 'package:campusvault/data/subject_data.dart';
import 'package:campusvault/models/academic_year.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/screens/subject_list_screen.dart';
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
    final subjects = getSubjectsForYear(
      courseId: course.id,
      yearId: year.id,
    );

    if (subjects != null) {
      Navigator.of(context).push(
        slideRoute(
          SubjectListScreen(
            university: university,
            college: college,
            programType: programType,
            course: course,
            year: year,
            subjects: subjects,
          ),
        ),
      );
    } else {
      // Curriculum not yet populated → coming soon screen
      Navigator.of(context).push(
        slideRoute(
          _ComingSoonScreen(
            university: university,
            college: college,
            programType: programType,
            course: course,
            year: year,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = getYearsForProgram(programType);

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

// ── Course context chip ───────────────────────────────────────────────────────
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
          Icon(Icons.book_outlined,
              size: 16, color: theme.colorScheme.primary),
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

// ── Coming soon screen for Architecture and unpopulated years ─────────────────
class _ComingSoonScreen extends StatelessWidget {
  final University university;
  final College college;
  final ProgramType programType;
  final Course course;
  final AcademicYear year;

  const _ComingSoonScreen({
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.construction_rounded,
                          size: 42,
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Curriculum coming soon',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'We are working on adding the curriculum for ${course.name} — ${year.label}. Check back soon.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
