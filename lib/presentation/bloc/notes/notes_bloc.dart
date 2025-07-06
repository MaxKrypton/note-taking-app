import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/note_model.dart';
import '../../../data/repositories/notes_repository.dart';

// Events
abstract class NotesEvent extends Equatable {
  const NotesEvent();
  
  @override
  List<Object?> get props => [];
}

class NotesLoadRequested extends NotesEvent {}

class NotesAddRequested extends NotesEvent {
  final String text;
  
  const NotesAddRequested({required this.text});
  
  @override
  List<Object?> get props => [text];
}

class NotesUpdateRequested extends NotesEvent {
  final String id;
  final String text;
  
  const NotesUpdateRequested({required this.id, required this.text});
  
  @override
  List<Object?> get props => [id, text];
}

class NotesDeleteRequested extends NotesEvent {
  final String id;
  
  const NotesDeleteRequested({required this.id});
  
  @override
  List<Object?> get props => [id];
}

// States
abstract class NotesState extends Equatable {
  const NotesState();
  
  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<NoteModel> notes;
  
  const NotesLoaded({required this.notes});
  
  @override
  List<Object?> get props => [notes];
}

class NotesError extends NotesState {
  final String message;
  
  const NotesError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class NotesOperationSuccess extends NotesState {
  final String message;
  final List<NoteModel> notes;
  
  const NotesOperationSuccess({required this.message, required this.notes});
  
  @override
  List<Object?> get props => [message, notes];
}

// BLoC
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;
  
  NotesBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(NotesInitial()) {
    
    on<NotesLoadRequested>(_onNotesLoadRequested);
    on<NotesAddRequested>(_onNotesAddRequested);
    on<NotesUpdateRequested>(_onNotesUpdateRequested);
    on<NotesDeleteRequested>(_onNotesDeleteRequested);
  }
  
  Future<void> _onNotesLoadRequested(
    NotesLoadRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading());
    try {
      final notes = await _notesRepository.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
  
  Future<void> _onNotesAddRequested(
    NotesAddRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.addNote(event.text);
      final notes = await _notesRepository.fetchNotes();
      emit(NotesOperationSuccess(
        message: 'Note added successfully!',
        notes: notes,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
  
  Future<void> _onNotesUpdateRequested(
    NotesUpdateRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.updateNote(event.id, event.text);
      final notes = await _notesRepository.fetchNotes();
      emit(NotesOperationSuccess(
        message: 'Note updated successfully!',
        notes: notes,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
  
  Future<void> _onNotesDeleteRequested(
    NotesDeleteRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.deleteNote(event.id);
      final notes = await _notesRepository.fetchNotes();
      emit(NotesOperationSuccess(
        message: 'Note deleted successfully!',
        notes: notes,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}