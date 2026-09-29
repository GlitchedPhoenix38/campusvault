import 'package:flutter/material.dart';

/// The type of resource that can be uploaded.
/// Firebase-ready: stored as a string in Firestore and mapped back via [fromString].
enum ResourceType {
  pdf('PDF', Icons.picture_as_pdf_rounded, Color(0xFFEF4444)),
  image('Image', Icons.image_rounded, Color(0xFF10B981)),
  externalLink('External Link', Icons.link_rounded, Color(0xFF3B82F6));

  final String label;
  final IconData icon;
  final Color color;

  const ResourceType(this.label, this.icon, this.color);

  static ResourceType fromString(String value) =>
      ResourceType.values.firstWhere(
        (t) => t.name == value,
        orElse: () => ResourceType.externalLink,
      );
}

/// Represents an uploadable academic resource attached to a specific
/// position in the University → College → Program → Year → Subject hierarchy.
///
/// Firebase-ready design:
/// - [id]           → Firestore document ID
/// - [storageUrl]   → Firebase Storage download URL (for PDF / image)
/// - [externalUrl]  → Used when [type] is [ResourceType.externalLink]
/// - [uploadedBy]   → Admin UID (links to `users/{uid}`)
/// - [uploadedAt]   → Timestamp for ordering / auditing
class Resource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;

  // Hierarchy context
  final String universityId;
  final String collegeId;
  final String programType;   // 'ug' | 'pg'
  final String courseId;
  final String yearId;
  final String subjectCode;

  // Storage
  final String? storageUrl;   // Firebase Storage URL (PDF / image)
  final String? externalUrl;  // Used for external links

  // Meta
  final String uploadedBy;    // Admin UID
  final DateTime uploadedAt;

  const Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.universityId,
    required this.collegeId,
    required this.programType,
    required this.courseId,
    required this.yearId,
    required this.subjectCode,
    this.storageUrl,
    this.externalUrl,
    required this.uploadedBy,
    required this.uploadedAt,
  });

  /// Creates a [Resource] from a Firestore document map.
  /// Uncomment when Firebase is integrated.
  // factory Resource.fromFirestore(Map<String, dynamic> data, String id) {
  //   return Resource(
  //     id: id,
  //     title: data['title'] as String,
  //     description: data['description'] as String,
  //     type: ResourceType.fromString(data['type'] as String),
  //     universityId: data['universityId'] as String,
  //     collegeId: data['collegeId'] as String,
  //     programType: data['programType'] as String,
  //     courseId: data['courseId'] as String,
  //     yearId: data['yearId'] as String,
  //     subjectCode: data['subjectCode'] as String,
  //     storageUrl: data['storageUrl'] as String?,
  //     externalUrl: data['externalUrl'] as String?,
  //     uploadedBy: data['uploadedBy'] as String,
  //     uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
  //   );
  // }

  // Map<String, dynamic> toFirestore() => {
  //   'title': title,
  //   'description': description,
  //   'type': type.name,
  //   'universityId': universityId,
  //   'collegeId': collegeId,
  //   'programType': programType,
  //   'courseId': courseId,
  //   'yearId': yearId,
  //   'subjectCode': subjectCode,
  //   'storageUrl': storageUrl,
  //   'externalUrl': externalUrl,
  //   'uploadedBy': uploadedBy,
  //   'uploadedAt': Timestamp.fromDate(uploadedAt),
  // };
}
