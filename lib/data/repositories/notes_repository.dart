import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Get notes collection reference for current user
  CollectionReference get _notesCollection =>
      _firestore.collection('users').doc(_currentUserId).collection('notes');

  // Fetch all notes for current user
  Future<List<NoteModel>> fetchNotes() async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    try {
      final querySnapshot = await _notesCollection
          .orderBy('updatedAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // Add a new note
  Future<void> addNote(String text) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
    if (text.trim().isEmpty) {
      throw Exception('Note text cannot be empty');
    }
    
    try {
      final now = DateTime.now();
      final note = NoteModel(
        id: '', // Firestore will generate this
        text: text.trim(),
        createdAt: now,
        updatedAt: now,
        userId: _currentUserId!,
      );
      
      await _notesCollection.add(note.toFirestore());
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Update an existing note
  Future<void> updateNote(String id, String text) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
    if (text.trim().isEmpty) {
      throw Exception('Note text cannot be empty');
    }
    
    try {
      await _notesCollection.doc(id).update({
        'text': text.trim(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
    
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // Stream of notes (for real-time updates)
  Stream<List<NoteModel>> notesStream() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }
    
    return _notesCollection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoteModel.fromFirestore(doc))
            .toList());
  }
}