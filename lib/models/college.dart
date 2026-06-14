import 'package:flutter/material.dart';

/// Represents a college/institute under a [University].
class College {
  final String id;
  final String name;
  final String shortName;
  final String universityId;
  final Color accentColor;
  final List<String> courseIds;

  const College({
    required this.id,
    required this.name,
    required this.shortName,
    required this.universityId,
    required this.accentColor,
    this.courseIds = const [],
  });
}
