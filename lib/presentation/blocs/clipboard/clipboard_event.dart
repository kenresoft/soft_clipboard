part of 'clipboard_bloc.dart';

abstract class ClipboardEvent extends Equatable {
  const ClipboardEvent();

  @override
  List<Object> get props => [];
}

class LoadClipboardItems extends ClipboardEvent {
  final List<ClipboardItem> items;

  const LoadClipboardItems(this.items);

  @override
  List<Object> get props => [items];
}

class ClipboardItemAdded extends ClipboardEvent {
  final ClipboardItem item;

  const ClipboardItemAdded(this.item);

  @override
  List<Object> get props => [item];
}

class ClipboardItemDeleted extends ClipboardEvent {
  final String id;

  const ClipboardItemDeleted(this.id);

  @override
  List<Object> get props => [id];
}

class ClipboardItemUpdated extends ClipboardEvent {
  final ClipboardItem item;

  const ClipboardItemUpdated(this.item);

  @override
  List<Object> get props => [item];
}

class ToggleClipboardItemPin extends ClipboardEvent {
  final ClipboardItem item;

  const ToggleClipboardItemPin(this.item);

  @override
  List<Object> get props => [item];
}

class ToggleClipboardItemFavorite extends ClipboardEvent {
  final ClipboardItem item;

  const ToggleClipboardItemFavorite(this.item);

  @override
  List<Object> get props => [item];
}

class CopyClipboardItemToClipboard extends ClipboardEvent {
  final ClipboardItem item;

  const CopyClipboardItemToClipboard(this.item);

  @override
  List<Object> get props => [item];
}

class StartListeningToClipboard extends ClipboardEvent {}

class StopListeningToClipboard extends ClipboardEvent {}

class SearchClipboardItems extends ClipboardEvent {
  final String query;

  const SearchClipboardItems(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends ClipboardEvent {}
