import 'package:flutter/material.dart';

/// Represents a university in the CampusVault hierarchy.
/// Scalable: colleges are linked via [collegeIds] allowing lazy-loading later.
class University {
  final String id;
  final String name;
  final String shortName;
  final String location;
  final Color accentColor;
  final List<String> collegeIds;

  const University({
    required this.id,
    required this.name,
    required this.shortName,
    required this.location,
    required this.accentColor,
    this.collegeIds = const [],
  });
}
