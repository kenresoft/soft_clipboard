part of 'clipboard_bloc.dart';

abstract class ClipboardState extends Equatable {
  const ClipboardState();

  @override
  List<Object> get props => [];
}

class ClipboardInitial extends ClipboardState {}

class ClipboardLoaded extends ClipboardState {
  final List<ClipboardItem> allItems;
  final List<ClipboardItem> items;
  final bool isSearchActive;
  final String searchQuery;

  const ClipboardLoaded({
    required this.allItems,
    required this.items,
    required this.isSearchActive,
    required this.searchQuery,
  });

  ClipboardLoaded copyWith({
    List<ClipboardItem>? allItems,
    List<ClipboardItem>? items,
    bool? isSearchActive,
    String? searchQuery,
  }) {
    return ClipboardLoaded(
      allItems: allItems ?? this.allItems,
      items: items ?? this.items,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [allItems, items, isSearchActive, searchQuery];
}

class ClipboardItemCopied extends ClipboardState {
  final ClipboardItem item;

  const ClipboardItemCopied(this.item);

  @override
  List<Object> get props => [item];
}
