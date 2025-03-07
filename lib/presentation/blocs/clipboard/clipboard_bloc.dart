import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_clipboard/data/datasources/clipboard_service.dart';
import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:soft_clipboard/domain/usecases/add_clipboard_item.dart';
import 'package:soft_clipboard/domain/usecases/delete_clipboard_item.dart';
import 'package:soft_clipboard/domain/usecases/get_clipboard_items.dart';
import 'package:soft_clipboard/domain/usecases/update_clipboard_item.dart';

part 'clipboard_event.dart';
part 'clipboard_state.dart';

class ClipboardBloc extends Bloc<ClipboardEvent, ClipboardState> {
  final GetClipboardItems getClipboardItems;
  final AddClipboardItem addClipboardItem;
  final UpdateClipboardItem updateClipboardItem;
  final DeleteClipboardItem deleteClipboardItem;
  final ClipboardService clipboardService;

  late StreamSubscription<List<ClipboardItem>> _clipboardSubscription;
  late StreamSubscription<ClipboardItem> _clipboardChangeSubscription;

  ClipboardBloc({
    required this.getClipboardItems,
    required this.addClipboardItem,
    required this.updateClipboardItem,
    required this.deleteClipboardItem,
    required this.clipboardService,
  }) : super(ClipboardInitial()) {
    on<LoadClipboardItems>(_onLoadClipboardItems);
    on<ClipboardItemAdded>(_onClipboardItemAdded);
    on<ClipboardItemDeleted>(_onClipboardItemDeleted);
    on<ClipboardItemUpdated>(_onClipboardItemUpdated);
    on<ToggleClipboardItemPin>(_onToggleClipboardItemPin);
    on<ToggleClipboardItemFavorite>(_onToggleClipboardItemFavorite);
    on<CopyClipboardItemToClipboard>(_onCopyClipboardItemToClipboard);
    on<StartListeningToClipboard>(_onStartListeningToClipboard);
    on<StopListeningToClipboard>(_onStopListeningToClipboard);
    on<SearchClipboardItems>(_onSearchClipboardItems);
    on<ClearSearch>(_onClearSearch);

    // Listen to clipboard items changes from repository
    _clipboardSubscription = getClipboardItems().listen(
      (items) => add(LoadClipboardItems(items)),
    );
  }

  Future<void> _onLoadClipboardItems(
    LoadClipboardItems event,
    Emitter<ClipboardState> emit,
  ) async {
    if (state is ClipboardLoaded) {
      final currentState = state as ClipboardLoaded;
      if (currentState.isSearchActive) {
        // Apply search filter
        final filteredItems = event.items
            .where(
              (item) => item.content.toLowerCase().contains(
                    currentState.searchQuery.toLowerCase(),
                  ),
            )
            .toList();

        emit(ClipboardLoaded(
          allItems: event.items,
          items: filteredItems,
          isSearchActive: true,
          searchQuery: currentState.searchQuery,
        ));
      } else {
        emit(ClipboardLoaded(
          allItems: event.items,
          items: event.items,
          isSearchActive: false,
          searchQuery: '',
        ));
      }
    } else {
      emit(ClipboardLoaded(
        allItems: event.items,
        items: event.items,
        isSearchActive: false,
        searchQuery: '',
      ));
    }
  }

  Future<void> _onClipboardItemAdded(
    ClipboardItemAdded event,
    Emitter<ClipboardState> emit,
  ) async {
    await addClipboardItem(event.item);
  }

  Future<void> _onClipboardItemDeleted(
    ClipboardItemDeleted event,
    Emitter<ClipboardState> emit,
  ) async {
    await deleteClipboardItem(event.id);
  }

  Future<void> _onClipboardItemUpdated(
    ClipboardItemUpdated event,
    Emitter<ClipboardState> emit,
  ) async {
    await updateClipboardItem(event.item);
  }

  Future<void> _onToggleClipboardItemPin(
    ToggleClipboardItemPin event,
    Emitter<ClipboardState> emit,
  ) async {
    await updateClipboardItem(
      event.item.copyWith(isPinned: !event.item.isPinned),
    );
  }

  Future<void> _onToggleClipboardItemFavorite(
    ToggleClipboardItemFavorite event,
    Emitter<ClipboardState> emit,
  ) async {
    await updateClipboardItem(
      event.item.copyWith(isFavorite: !event.item.isFavorite),
    );
  }

  Future<void> _onCopyClipboardItemToClipboard(
    CopyClipboardItemToClipboard event,
    Emitter<ClipboardState> emit,
  ) async {
    await clipboardService.copyToClipboard(event.item.content);
    emit(ClipboardItemCopied(event.item));

    // After showing copied status, revert to loaded state
    if (state is ClipboardLoaded) {
      final loadedState = state as ClipboardLoaded;
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) {
          emit(loadedState.copyWith());
        }
      });
    }
  }

  Future<void> _onStartListeningToClipboard(
    StartListeningToClipboard event,
    Emitter<ClipboardState> emit,
  ) async {
    await clipboardService.startListening();

    // Listen to clipboard changes
    _clipboardChangeSubscription = clipboardService.clipboardChanges.listen(
      (item) => add(ClipboardItemAdded(item)),
    );
  }

  Future<void> _onStopListeningToClipboard(
    StopListeningToClipboard event,
    Emitter<ClipboardState> emit,
  ) async {
    await clipboardService.stopListening();
    await _clipboardChangeSubscription.cancel();
  }

  Future<void> _onSearchClipboardItems(
    SearchClipboardItems event,
    Emitter<ClipboardState> emit,
  ) async {
    if (state is ClipboardLoaded) {
      final loadedState = state as ClipboardLoaded;

      final filteredItems = loadedState.allItems
          .where(
            (item) => item.content.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
          )
          .toList();

      emit(ClipboardLoaded(
        allItems: loadedState.allItems,
        items: filteredItems,
        isSearchActive: true,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<ClipboardState> emit,
  ) async {
    if (state is ClipboardLoaded) {
      final loadedState = state as ClipboardLoaded;

      emit(ClipboardLoaded(
        allItems: loadedState.allItems,
        items: loadedState.allItems,
        isSearchActive: false,
        searchQuery: '',
      ));
    }
  }

  @override
  Future<void> close() {
    _clipboardSubscription.cancel();
    if (_clipboardChangeSubscription != null) {
      _clipboardChangeSubscription.cancel();
    }
    return super.close();
  }
}
