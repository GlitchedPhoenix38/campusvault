import 'package:flutter/material.dart';
import 'package:campusvault/models/university.dart';
import 'package:campusvault/models/college.dart';
import 'package:campusvault/models/course.dart';
import 'package:campusvault/models/academic_year.dart';

// ---------------------------------------------------------------------------
// UNIVERSITIES
// ---------------------------------------------------------------------------

final List<University> universities = [
  const University(
    id: 'mgm',
    name: 'MGM University',
    shortName: 'MGM',
    location: 'Chhatrapati Sambhajinagar, Maharashtra',
    accentColor: Color(0xFFD946EF),
    collegeIds: ['jnec'],
  ),
];

// ---------------------------------------------------------------------------
// COLLEGES
// ---------------------------------------------------------------------------

final List<College> colleges = [
  const College(
    id: 'jnec',
    name: 'Jawaharlal Nehru Engineering College',
    shortName: 'JNEC',
    universityId: 'mgm',
    accentColor: Color(0xFF4F46E5),
    courseIds: [
      'jnec_cse', 'jnec_aids', 'jnec_mech', 'jnec_civil', 'jnec_chem',
      'jnec_ece', 'jnec_ecom', 'jnec_rai', 'jnec_arch',
      'jnec_mca', 'jnec_mech_mtech', 'jnec_vlsi', 'jnec_structural',
      'jnec_eps', 'jnec_cse_dt', 'jnec_march_env', 'jnec_march_int',
    ],
  ),
];

// ---------------------------------------------------------------------------
// COURSES
// ---------------------------------------------------------------------------

final List<Course> courses = [
  // ── UG ──────────────────────────────────────────────────────────────────
  const Course(
    id: 'jnec_cse',
    name: 'Computer Science and Engineering',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_aids',
    name: 'Artificial Intelligence and Data Science',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_mech',
    name: 'Mechanical Engineering',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_civil',
    name: 'Civil Engineering',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_chem',
    name: 'Chemical Engineering',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_ece',
    name: 'Electronics and Computer Engineering',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_ecom',
    name: 'Electrical and Computer Engineering',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_rai',
    name: 'Robotics and Artificial Intelligence',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_arch',
    name: 'Architecture',
    programType: ProgramType.ug,
    collegeId: 'jnec',
  ),

  // ── PG ──────────────────────────────────────────────────────────────────
  const Course(
    id: 'jnec_mca',
    name: 'Master of Computer Applications',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_mech_mtech',
    name: 'Mechanical Engineering MTech',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_vlsi',
    name: 'VLSI and Embedded Systems',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_structural',
    name: 'Structural Engineering',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_eps',
    name: 'Electrical Power Systems',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_cse_dt',
    name: 'Computer Science and Engineering (Digital Transformation)',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_march_env',
    name: 'Masters of Architecture (Environmental)',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
  const Course(
    id: 'jnec_march_int',
    name: 'Masters of Architecture (Interior Design)',
    programType: ProgramType.pg,
    collegeId: 'jnec',
  ),
];

// ---------------------------------------------------------------------------
// ACADEMIC YEARS (derived per program type — no duplication)
// ---------------------------------------------------------------------------

final List<AcademicYear> ugYears = [
  const AcademicYear(id: 'ug_y1', label: 'First Year',  yearNumber: 1, programType: ProgramType.ug),
  const AcademicYear(id: 'ug_y2', label: 'Second Year', yearNumber: 2, programType: ProgramType.ug),
  const AcademicYear(id: 'ug_y3', label: 'Third Year',  yearNumber: 3, programType: ProgramType.ug),
  const AcademicYear(id: 'ug_y4', label: 'Fourth Year', yearNumber: 4, programType: ProgramType.ug),
];

final List<AcademicYear> pgYears = [
  const AcademicYear(id: 'pg_y1', label: 'First Year',  yearNumber: 1, programType: ProgramType.pg),
  const AcademicYear(id: 'pg_y2', label: 'Second Year', yearNumber: 2, programType: ProgramType.pg),
];

// ---------------------------------------------------------------------------
// LOOKUP HELPERS — O(1) access by id
// ---------------------------------------------------------------------------

/// Returns the [University] matching [id], or null.
University? getUniversityById(String id) {
  try {
    return universities.firstWhere((u) => u.id == id);
  } catch (_) {
    return null;
  }
}

/// Returns all [College]s belonging to [universityId].
List<College> getCollegesForUniversity(String universityId) =>
    colleges.where((c) => c.universityId == universityId).toList();

/// Returns all [Course]s for [collegeId] filtered by [programType].
List<Course> getCoursesForCollege(String collegeId, ProgramType programType) =>
    courses
        .where((c) => c.collegeId == collegeId && c.programType == programType)
        .toList();

/// Returns the correct year list for [programType].
List<AcademicYear> getYearsForProgram(ProgramType programType) =>
    programType == ProgramType.ug ? ugYears : pgYears;
