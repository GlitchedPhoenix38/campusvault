import 'package:flutter/material.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/screens/course_selection_screen.dart';
import 'package:campusvault/utils/route_transitions.dart';
import 'package:campusvault/widgets/breadcrumb_bar.dart';
import 'package:campusvault/widgets/selection_card.dart';

class ProgramTypeScreen extends StatelessWidget {
  final University university;
  final College college;

  const ProgramTypeScreen({
    super.key,
    required this.university,
    required this.college,
  });

  void _onProgramTypeTapped(BuildContext context, ProgramType programType) {
    Navigator.of(context).push(
      slideRoute(
        CourseSelectionScreen(
          university: university,
          college: college,
          programType: programType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Program Type'),
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
                'Program',
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 8),
                  _ProgramCard(
                    programType: ProgramType.ug,
                    description: "Bachelor's degree programs (4 years)",
                    onTap: () =>
                        _onProgramTypeTapped(context, ProgramType.ug),
                  ),
                  const SizedBox(height: 12),
                  _ProgramCard(
                    programType: ProgramType.pg,
                    description: "Master's degree programs (2 years)",
                    onTap: () =>
                        _onProgramTypeTapped(context, ProgramType.pg),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private card for program type — only used on this screen ────────────────
class _ProgramCard extends StatelessWidget {
  final ProgramType programType;
  final String description;
  final VoidCallback onTap;

  const _ProgramCard({
    required this.programType,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUg = programType == ProgramType.ug;
    final color =
        isUg ? const Color(0xFF4F46E5) : const Color(0xFF0D9488);

    return SelectionCard(
      title: '${programType.code} — ${programType.label}',
      subtitle: description,
      accentColor: color,
      avatarLabel: programType.code,
      onTap: onTap,
    );
  }
}
