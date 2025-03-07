import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soft_clipboard/domain/entities/clipboard_item.dart';
import 'package:soft_clipboard/presentation/blocs/clipboard/clipboard_bloc.dart';
import 'package:soft_clipboard/presentation/widgets/clipboard_item_card.dart';
import 'package:soft_clipboard/presentation/widgets/empty_state.dart';

class ClipboardHistoryPage extends StatefulWidget {
  const ClipboardHistoryPage({super.key});

  @override
  State<ClipboardHistoryPage> createState() => _ClipboardHistoryPageState();
}

class _ClipboardHistoryPageState extends State<ClipboardHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<ClipboardBloc>().add(SearchClipboardItems(query));
    } else {
      context.read<ClipboardBloc>().add(ClearSearch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipboard History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ClipboardSearchDelegate(context.read<ClipboardBloc>()),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ClipboardBloc, ClipboardState>(
        listenWhen: (previous, current) => current is ClipboardItemCopied,
        listener: (context, state) {
          if (state is ClipboardItemCopied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied to clipboard'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        buildWhen: (previous, current) => current is ClipboardLoaded,
        builder: (context, state) {
          if (state is ClipboardLoaded) {
            if (state.items.isEmpty) {
              return EmptyState(
                title: 'No clipboard items',
                message: 'Copy some text to see it here',
                animationAsset: 'assets/animations/empty_clipboard.json',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                // Trigger a refresh of the clipboard items
                // This is mostly a UX feature as the stream will update automatically
              },
              child: ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ClipboardItemCard(
                    item: item,
                    onTap: () {
                      // Show detailed view of the clipboard item
                      _showClipboardItemDetails(context, item);
                    },
                    onCopy: () {
                      context.read<ClipboardBloc>().add(
                            CopyClipboardItemToClipboard(item),
                          );
                    },
                    onDelete: () {
                      _confirmDeleteItem(context, item);
                    },
                    onTogglePinned: () {
                      context.read<ClipboardBloc>().add(
                            ToggleClipboardItemPin(item),
                          );
                    },
                    onToggleFavorite: () {
                      context.read<ClipboardBloc>().add(
                            ToggleClipboardItemFavorite(item),
                          );
                    },
                    onEdit: () {
                      _editClipboardItem(context, item);
                    },
                  );
                },
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.clear_all),
        onPressed: () {
          _confirmClearAllItems(context);
        },
        tooltip: 'Clear all items',
      ),
    );
  }

  void _showClipboardItemDetails(BuildContext context, ClipboardItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Copied on: ${DateFormat.yMMMd().add_Hms().format(item.timestamp)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteItem(BuildContext context, ClipboardItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ClipboardBloc>().add(
                      ClipboardItemDeleted(item.id),
                    );
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearAllItems(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All Items'),
          content: const Text('Are you sure you want to clear all items?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // context.read<ClipboardBloc>().add(ClearAllItems());
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _editClipboardItem(BuildContext context, ClipboardItem item) {
    final textController = TextEditingController(text: item.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: TextField(
            controller: textController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedItem = item.copyWith(
                  content: textController.text.trim(),
                );
                context.read<ClipboardBloc>().add(
                      ClipboardItemUpdated(updatedItem),
                    );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class ClipboardSearchDelegate extends SearchDelegate<String> {
  final ClipboardBloc clipboardBloc;

  ClipboardSearchDelegate(this.clipboardBloc);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 'null');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    clipboardBloc.add(SearchClipboardItems(query));

    return BlocBuilder<ClipboardBloc, ClipboardState>(
      builder: (context, state) {
        if (state is ClipboardLoaded) {
          if (state.items.isEmpty) {
            return const Center(
              child: Text('No results found'),
            );
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ListTile(
                title: Text(item.content),
                onTap: () {
                  close(context, item.content);
                },
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
