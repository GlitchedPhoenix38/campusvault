import 'package:campusvault/models/subject.dart';

// ---------------------------------------------------------------------------
// JNEC — UG FIRST YEAR ENGINEERING (shared across all UG branches except Arch)
// ---------------------------------------------------------------------------
// Course IDs that share this common First Year subject list:
// jnec_cse, jnec_aids, jnec_mech, jnec_civil, jnec_chem,
// jnec_ece, jnec_ecom, jnec_rai

const Set<String> _ugEnggFirstYearCourseIds = {
  'jnec_cse',
  'jnec_aids',
  'jnec_mech',
  'jnec_civil',
  'jnec_chem',
  'jnec_ece',
  'jnec_ecom',
  'jnec_rai',
};

/// All 24 First Year Engineering subjects for JNEC UG (non-Architecture).
const List<Subject> jnecUgFirstYearSubjects = [
  // ── Semester I ────────────────────────────────────────────────────────────
  Subject(
    code: 'APS21BSL101',
    name: 'Single and Multivariable Calculus',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21BSL104',
    name: 'Engineering Chemistry',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21BSP102',
    name: 'Engineering Chemistry Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21ESL101',
    name: 'Python Programming',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21ESL103',
    name: 'Engineering Mechanics',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21ESP101',
    name: 'Python Programming Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21ESP104',
    name: 'Engineering Mechanics Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21PCL101',
    name: 'Basics of Electrical and Electronics Engineering',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21PCP101',
    name: 'Electrical and Electronics Technology Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21VSP102',
    name: 'Workshop Practices',
    credits: 2,
    sessions: 48,
  ),
  Subject(
    code: 'MGM54AEL101',
    name: 'Communicative English',
    credits: 2,
    sessions: 32,
  ),
  Subject(
    code: 'MGM54AEP101',
    name: 'Communicative English Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'MGM82CCP',
    name: 'Co-Curricular Course',
    credits: 1,
    sessions: 16,
  ),
  Subject(
    code: 'MGM82CCP103',
    name: 'Sports',
    credits: 1,
    sessions: 16,
  ),

  // ── Semester II ───────────────────────────────────────────────────────────
  Subject(
    code: 'APS21BSL102',
    name: 'Engineering Physics',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21BSL103',
    name: 'Linear Algebra and Differential Equations',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21BSP101',
    name: 'Engineering Physics Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21ESL102',
    name: 'Engineering Graphics',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21ESL104',
    name: 'Building Programming Logic in C',
    credits: 3,
    sessions: 48,
  ),
  Subject(
    code: 'APS21ESP102',
    name: 'Engineering Graphics Studio',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21ESP103',
    name: 'Recent Trends in Integrated Technology',
    credits: 1,
    sessions: 16,
  ),
  Subject(
    code: 'APS21ESP105',
    name: 'Building Programming Logic in C Lab',
    credits: 1,
    sessions: 32,
  ),
  Subject(
    code: 'APS21IKL101',
    name: 'Indian Knowledge System',
    credits: 2,
    sessions: 32,
  ),
  Subject(
    code: 'APS21VSP101',
    name: 'Engineering Exploration',
    credits: 1,
    sessions: 16,
  ),
];

// ---------------------------------------------------------------------------
// PUBLIC LOOKUP HELPER
// ---------------------------------------------------------------------------

/// Returns the subject list for [courseId] + [yearId].
/// Returns null when no subjects are defined yet (shows "coming soon").
List<Subject>? getSubjectsForYear({
  required String courseId,
  required String yearId,
}) {
  // First Year Engineering (non-Architecture UG)
  if (_ugEnggFirstYearCourseIds.contains(courseId) && yearId == 'ug_y1') {
    return jnecUgFirstYearSubjects;
  }
  // Architecture and all other years → null (coming soon)
  return null;
}
