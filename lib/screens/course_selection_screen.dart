import 'package:flutter/material.dart';
import 'package:campusvault/data/academic_data.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/screens/academic_year_screen.dart';
import 'package:campusvault/utils/route_transitions.dart';
import 'package:campusvault/widgets/breadcrumb_bar.dart';
import 'package:campusvault/widgets/empty_state.dart';
import 'package:campusvault/widgets/search_bar_widget.dart';
import 'package:campusvault/widgets/selection_card.dart';

class CourseSelectionScreen extends StatefulWidget {
  final University university;
  final College college;
  final ProgramType programType;

  const CourseSelectionScreen({
    super.key,
    required this.university,
    required this.college,
    required this.programType,
  });

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Course> _allCourses;
  late List<Course> _filtered;

  // Distinct colors for course cards to avoid visual monotony
  static const List<Color> _palette = [
    Color(0xFF4F46E5), // Indigo
    Color(0xFF0D9488), // Teal
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFFD946EF), // Fuchsia
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Violet
    Color(0xFFF97316), // Orange
  ];

  Color _colorForIndex(int index) => _palette[index % _palette.length];

  @override
  void initState() {
    super.initState();
    _allCourses =
        getCoursesForCollege(widget.college.id, widget.programType);
    _filtered = _allCourses;
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
      _filtered =
          _allCourses.where((c) => c.name.toLowerCase().contains(q)).toList();
    });
  }

  void _onCourseTapped(Course course, int originalIndex) {
    Navigator.of(context).push(
      slideRoute(
        AcademicYearScreen(
          university: widget.university,
          college: widget.college,
          programType: widget.programType,
          course: course,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.programType.code} Courses'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreadcrumbBar(
              crumbs: [
                widget.university.shortName,
                widget.college.shortName,
                widget.programType.code,
                'Course',
              ],
            ),
            SearchBarWidget(
              controller: _searchController,
              hintText: 'Search course…',
              onClear: () => _searchController.clear(),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const EmptyState(
                      icon: Icons.menu_book_outlined,
                      message: 'No courses found',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final course = _filtered[index];
                        // Find original index in _allCourses for stable colour
                        final originalIndex = _allCourses.indexOf(course);
                        final color = _colorForIndex(originalIndex);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SelectionCard(
                            title: course.name,
                            accentColor: color,
                            avatarIcon: Icons.book_outlined,
                            onTap: () =>
                                _onCourseTapped(course, originalIndex),
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
