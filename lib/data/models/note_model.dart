import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const NoteModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  // Convert from Firestore document
  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
    };
  }

  // Create a copy with updated fields
  NoteModel copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return NoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, text, createdAt, updatedAt, userId];
}