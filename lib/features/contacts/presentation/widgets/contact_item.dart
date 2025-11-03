// lib/features/contacts/presentation/widgets/contact_item.dart

import 'package:flutter/material.dart';
import '../../models/contact.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ContactItem({
    Key? key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProspect = contact.type == ContactType.prospect;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: theme.colorScheme.surface,
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: isProspect
              ? theme.colorScheme.secondary
              : theme.colorScheme.primary,
          child: Text(
            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contact.name,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.company.isNotEmpty)
              Text(
                contact.company,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            Text(
              'Mobile: ${contact.phoneNumber}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info_outline),
              color: isProspect
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.primary,
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
