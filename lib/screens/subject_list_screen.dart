import 'package:flutter/material.dart';
import 'package:campusvault/models/academic_year.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/subject.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/screens/subject_detail_screen.dart';
import 'package:campusvault/utils/route_transitions.dart';
import 'package:campusvault/widgets/breadcrumb_bar.dart';
import 'package:campusvault/widgets/empty_state.dart';
import 'package:campusvault/widgets/search_bar_widget.dart';

class SubjectListScreen extends StatefulWidget {
  final University university;
  final College college;
  final ProgramType programType;
  final Course course;
  final AcademicYear year;
  final List<Subject> subjects;

  const SubjectListScreen({
    super.key,
    required this.university,
    required this.college,
    required this.programType,
    required this.course,
    required this.year,
    required this.subjects,
  });

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Subject> _filtered;

  // Palette cycles for subject cards
  static const List<Color> _palette = [
    Color(0xFF4F46E5),
    Color(0xFF0D9488),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFD946EF),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _filtered = widget.subjects;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    setState(() {
      _filtered = widget.subjects.where((s) {
        return s.name.toLowerCase().contains(q) ||
            s.code.toLowerCase().contains(q);
      }).toList();
    });
  }

  List<String> get _breadcrumbs => [
        widget.university.shortName,
        widget.college.shortName,
        widget.programType.code,
        widget.year.label,
      ];

  void _onSubjectTapped(Subject subject) {
    Navigator.of(context).push(
      slideRoute(
        SubjectDetailScreen(
          subject: subject,
          breadcrumbs: _breadcrumbs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.year.label),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreadcrumbBar(crumbs: _breadcrumbs),
            // Course context chip
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _CourseChip(course: widget.course),
            ),
            SearchBarWidget(
              controller: _searchController,
              hintText: 'Search subject…',
              onClear: () => _searchController.clear(),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const EmptyState(
                      icon: Icons.menu_book_outlined,
                      message: 'No subjects found',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final subject = _filtered[index];
                        // Use stable index from full list for colour consistency
                        final stableIdx = widget.subjects.indexOf(subject);
                        final color =
                            _palette[stableIdx % _palette.length];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SubjectCard(
                            subject: subject,
                            accentColor: color,
                            onTap: () => _onSubjectTapped(subject),
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

// ── Compact course chip ───────────────────────────────────────────────────────
class _CourseChip extends StatelessWidget {
  final Course course;
  const _CourseChip({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.book_outlined,
              size: 15, color: theme.colorScheme.primary),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              course.name,
              style: TextStyle(
                fontSize: 12,
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

// ── Subject card ──────────────────────────────────────────────────────────────
class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final Color accentColor;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.accentColor,
    required this.onTap,
  });

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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Coloured left accent bar
              Container(
                width: 4,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              // Subject info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject code badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        subject.code,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subject.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Credits + Sessions pills
                    Row(
                      children: [
                        _Pill(
                          icon: Icons.stars_rounded,
                          label: '${subject.credits} Credits',
                          color: accentColor,
                        ),
                        const SizedBox(width: 8),
                        _Pill(
                          icon: Icons.schedule_rounded,
                          label: '${subject.sessions} Sessions',
                          color: accentColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color.withValues(alpha: 0.8)),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
