import 'package:flutter/material.dart';
import 'package:campusvault/models/university.dart';

final List<University> sampleUniversities = [
  const University(
    id: 'dbatu',
    name: 'Dr. Babasaheb Ambedkar Technological University',
    shortName: 'DBATU',
    location: 'Lonere, Maharashtra',
    accentColor: Color(0xFF4F46E5), // Indigo
  ),
  const University(
    id: 'sppu',
    name: 'Savitribai Phule Pune University',
    shortName: 'SPPU',
    location: 'Pune, Maharashtra',
    accentColor: Color(0xFFF59E0B), // Amber
  ),
  const University(
    id: 'mu',
    name: 'Mumbai University',
    shortName: 'MU',
    location: 'Mumbai, Maharashtra',
    accentColor: Color(0xFF0D9488), // Teal
  ),
  const University(
    id: 'mgm',
    name: 'MGM University',
    shortName: 'MGM',
    location: 'Chhatrapati Sambhajinagar, Maharashtra',
    accentColor: Color(0xFFD946EF), // Fuchsia
  ),
  const University(
    id: 'mitwpu',
    name: 'MIT World Peace University',
    shortName: 'MIT-WPU',
    location: 'Pune, Maharashtra',
    accentColor: Color(0xFFEF4444), // Red
  ),
];
