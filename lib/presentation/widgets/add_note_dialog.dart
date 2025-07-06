import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes/notes_bloc.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<NotesBloc>().add(
            NotesAddRequested(text: _textController.text.trim()),
          );
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
      title: const Text('Add New Note'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textController,
          validator: _validateText,
          autofocus: true,
          maxLines: 5,
          maxLength: 500,
          decoration: const InputDecoration(
            hintText: 'Enter your note here...',
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
          onPressed: _addNote,
          child: const Text('Add Note'),
        ),
      ],
    );
  }
}