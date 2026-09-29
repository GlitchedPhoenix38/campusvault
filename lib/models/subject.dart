/// Represents a single academic subject within a year of a course.
/// Scalable: notes, PYQs, syllabus, and resources will be linked here later.
class Subject {
  final String code;
  final String name;
  final int credits;
  final int sessions;

  const Subject({
    required this.code,
    required this.name,
    required this.credits,
    required this.sessions,
  });
}
