import 'package:flutter/material.dart';

class University {
  final String id;
  final String name;
  final String shortName;
  final String location;
  final Color accentColor;

  const University({
    required this.id,
    required this.name,
    required this.shortName,
    required this.location,
    required this.accentColor,
  });
}
