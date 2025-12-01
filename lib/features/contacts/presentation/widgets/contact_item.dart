// lib/features/contacts/presentation/widgets/contact_item.dart

import 'package:flutter/material.dart';
import '../../../../core/themes/app_theme.dart';
import '../../models/contact.dart';
import 'contact_utils.dart';

class ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const ContactItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isProspect = contact.type == 'prospect'; // example field

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor:
                    isProspect ? AppColors.secondary : AppColors.primary,
                child: Text(
                  ContactUtils.getInitials(contact.name),
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: AppTextStyles.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (contact.company.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        contact.company,
                        style: AppTextStyles.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 4),
                    Text(
                      'Mobile: ${contact.phoneNumber}',
                      style: AppTextStyles.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
