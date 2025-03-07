import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:soft_clipboard/domain/entities/clipboard_item.dart';

class ClipboardItemCard extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onTap;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback onTogglePinned;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onEdit;

  const ClipboardItemCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.onCopy,
    required this.onDelete,
    required this.onTogglePinned,
    required this.onToggleFavorite,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: item.isPinned ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: item.isPinned ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeIcon(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContentPreview(),
                        const SizedBox(height: 4),
                        _buildTimestamp(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData iconData;
    Color iconColor;

    switch (item.type) {
      case ClipboardItemType.link:
        iconData = Icons.link;
        iconColor = Colors.blue;
        break;
      case ClipboardItemType.email:
        iconData = Icons.email;
        iconColor = Colors.red;
        break;
      case ClipboardItemType.phoneNumber:
        iconData = Icons.phone;
        iconColor = Colors.green;
        break;
      case ClipboardItemType.text:
      case ClipboardItemType.other:
      default:
        iconData = Icons.text_fields;
        iconColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: iconColor),
    );
  }

  Widget _buildContentPreview() {
    return Text(
      item.content,
      style: const TextStyle(fontSize: 16),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTimestamp() {
    final formattedDate = DateFormat.yMMMd().add_Hm().format(item.timestamp);

    return Text(
      formattedDate,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            item.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            color: item.isPinned ? Theme.of(context).colorScheme.primary : null,
          ),
          onPressed: onTogglePinned,
          tooltip: item.isPinned ? 'Unpin' : 'Pin',
        ),
        IconButton(
          icon: Icon(
            item.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: item.isFavorite ? Colors.red : null,
          ),
          onPressed: onToggleFavorite,
          tooltip: item.isFavorite ? 'Remove from favorites' : 'Add to favorites',
        ),
        IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: onCopy,
          tooltip: 'Copy',
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => Share.share(item.content),
          tooltip: 'Share',
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
          tooltip: 'Delete',
        ),
      ],
    );
  }
}
