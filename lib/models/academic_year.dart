import 'package:campusvault/models/course.dart';

/// Represents an academic year within a course.
/// [label] is what is shown in the UI (e.g., "First Year").
/// [yearNumber] is the numeric value (1–4 for UG, 1–2 for PG).
class AcademicYear {
  final String id;
  final String label;
  final int yearNumber;
  final ProgramType programType;

  const AcademicYear({
    required this.id,
    required this.label,
    required this.yearNumber,
    required this.programType,
  });
}
