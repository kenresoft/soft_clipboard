import 'package:equatable/equatable.dart';

enum ClipboardItemType {
  text,
  link,
  email,
  phoneNumber,
  other,
}

class ClipboardItem extends Equatable {
  final String id;
  final String content;
  final DateTime timestamp;
  final ClipboardItemType type;
  final bool isPinned;
  final bool isFavorite;

  const ClipboardItem({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.type,
    this.isPinned = false,
    this.isFavorite = false,
  });

  ClipboardItem copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    ClipboardItemType? type,
    bool? isPinned,
    bool? isFavorite,
  }) {
    return ClipboardItem(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, content, timestamp, type, isPinned, isFavorite];

  static ClipboardItemType detectType(String content) {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    final phoneRegex = RegExp(r'^\+?[\d\s-]{7,15}$');

    if (urlRegex.hasMatch(content)) {
      return ClipboardItemType.link;
    } else if (emailRegex.hasMatch(content)) {
      return ClipboardItemType.email;
    } else if (phoneRegex.hasMatch(content)) {
      return ClipboardItemType.phoneNumber;
    } else {
      return ClipboardItemType.text;
    }
  }
}