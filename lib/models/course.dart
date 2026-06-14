/// Enum defining the two program types in the academic hierarchy.
enum ProgramType {
  ug('UG', 'Undergraduate'),
  pg('PG', 'Postgraduate');

  final String code;
  final String label;

  const ProgramType(this.code, this.label);
}

/// Represents an academic course (e.g., CSE, MCA) under a college + program type.
class Course {
  final String id;
  final String name;
  final ProgramType programType;
  final String collegeId;

  const Course({
    required this.id,
    required this.name,
    required this.programType,
    required this.collegeId,
  });
}
