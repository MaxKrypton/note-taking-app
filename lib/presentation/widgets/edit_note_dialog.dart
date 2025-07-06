import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note_model.dart';
import '../bloc/notes/notes_bloc.dart';

class EditNoteDialog extends StatefulWidget {
  final NoteModel note;

  const EditNoteDialog({super.key, required this.note});

  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.note.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateNote() {
    if (_formKey.currentState?.validate() ?? false) {
      final newText = _textController.text.trim();
      if (newText != widget.note.text) {
        context.read<NotesBloc>().add(
              NotesUpdateRequested(
                id: widget.note.id,
                text: newText,
              ),
            );
      }
      Navigator.of(context).pop();
    }
  }

  String? _validateText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter some text for your note';
    }
    if (value.trim().length > 500) {
      return 'Note text cannot exceed 500 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          validator: _validateText,
          autofocus: true,
          maxLines: 5,
          maxLength: 500,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '', // Hide character counter
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateNote,
          child: const Text('Update'),
        ),
      ],
    );
  }
}