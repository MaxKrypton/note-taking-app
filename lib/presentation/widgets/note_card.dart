import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/note_model.dart';
import 'edit_note_dialog.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onDelete,
  });

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(note: note),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note text
            Text(
              note.text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            
            // Bottom row with date and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(note.updatedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 20,
                      onPressed: () => _showEditDialog(context),
                      tooltip: 'Edit note',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      iconSize: 20,
                      color: Colors.red,
                      onPressed: onDelete,
                      tooltip: 'Delete note',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}