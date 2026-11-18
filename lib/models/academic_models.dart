import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class User {
  final String id;
  final String curp;
  final String fullName;
  final String email;
  final String phone;
  final String avatarUrl;
  final UserRole role;
  final String institution;
  final String career;
  final String group;
  final String description;
  final DateTime createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.curp,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.role,
    required this.institution,
    required this.career,
    required this.group,
    required this.description,
    required this.createdAt,
    this.isActive = true,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }

  User copyWith({
    String? id,
    String? curp,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    String? institution,
    String? career,
    String? group,
    String? description,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      curp: curp ?? this.curp,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      institution: institution ?? this.institution,
      career: career ?? this.career,
      group: group ?? this.group,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class Subject {
  final String id;
  final String name;
  final String code;
  final String teacherId;
  final String teacherName;
  final String group;
  final String schedule;
  final String classroom;
  final int credits;
  final Color color;
  final String description;

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.teacherId,
    required this.teacherName,
    required this.group,
    required this.schedule,
    required this.classroom,
    required this.credits,
    required this.color,
    required this.description,
  });
}

class Grade {
  final String id;
  final String subjectId;
  final String subjectName;
  final String evaluationName;
  final EvaluationType type;
  final double score;
  final double maxScore;
  final double weight;
  final DateTime date;
  final String teacherId;
  final String teacherName;
  final String? feedback;

  const Grade({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.evaluationName,
    required this.type,
    required this.score,
    required this.maxScore,
    required this.weight,
    required this.date,
    required this.teacherId,
    required this.teacherName,
    this.feedback,
  });

  double get percentage => (score / maxScore) * 100;
  String get formattedScore => '${score.toStringAsFixed(1)}/${maxScore.toStringAsFixed(0)}';
}

class AttendanceRecord {
  final String id;
  final String subjectId;
  final String subjectName;
  final DateTime date;
  final AttendanceStatus status;
  final String? justification;
  final String sessionId;
  final String teacherName;

  const AttendanceRecord({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.date,
    required this.status,
    this.justification,
    required this.sessionId,
    required this.teacherName,
  });
}

class Session {
  final String id;
  final String subjectId;
  final String subjectName;
  final String group;
  final String teacherId;
  final String teacherName;
  final DateTime startTime;
  final DateTime endTime;
  final String classroom;
  final SessionStatus status;
  final List<String> studentIds;
  final String? topic;
  final String? description;

  const Session({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.group,
    required this.teacherId,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.classroom,
    required this.status,
    required this.studentIds,
    this.topic,
    this.description,
  });

  Duration get duration => endTime.difference(startTime);
}

class Evaluation {
  final String id;
  final String subjectId;
  final String name;
  final String description;
  final EvaluationType type;
  final double weight;
  final double maxScore;
  final DateTime date;
  final DateTime? dueDate;
  final String teacherId;
  final List<String> criteria;

  const Evaluation({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.description,
    required this.type,
    required this.weight,
    required this.maxScore,
    required this.date,
    this.dueDate,
    required this.teacherId,
    required this.criteria,
  });
}

class TeacherReview {
  final String id;
  final String teacherId;
  final String teacherName;
  final String studentId;
  final String studentName;
  final String category;
  final String content;
  final int rating;
  final DateTime date;
  final bool isAnonymous;

  const TeacherReview({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.studentId,
    required this.studentName,
    required this.category,
    required this.content,
    required this.rating,
    required this.date,
    this.isAnonymous = true,
  });
}

class Group {
  final String id;
  final String name;
  final String career;
  final int semester;
  final int studentCount;
  final List<String> subjectIds;
  final String tutorId;
  final String tutorName;

  const Group({
    required this.id,
    required this.name,
    required this.career,
    required this.semester,
    required this.studentCount,
    required this.subjectIds,
    required this.tutorId,
    required this.tutorName,
  });
}

class StudentActivity {
  final String studentId;
  final String studentName;
  final String application;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAllowed;
  final String category;

  const StudentActivity({
    required this.studentId,
    required this.studentName,
    required this.application,
    required this.startTime,
    required this.endTime,
    required this.isAllowed,
    required this.category,
  });

  Duration get duration => endTime.difference(startTime);
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime date;
  final bool isRead;
  final String? actionUrl;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isRead = false,
    this.actionUrl,
  });
}