import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final _noticesProvider =
    FutureProvider.autoDispose.family<List<Notice>, String>(
        (ref, hostelId) async =>
            ref.watch(broadcastApiProvider).getNotices(hostelId));

class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final hostelId = user?.hostelId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(_noticesProvider(hostelId)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewNotice(context, ref, hostelId),
        icon: const Icon(Icons.post_add_rounded),
        label: const Text('New Notice'),
        backgroundColor: AppColors.primary,
      ),
      body: hostelId.isEmpty
          ? const DcEmptyState(
              icon: Icons.home_work_outlined,
              title: 'No hostel assigned')
          : _Body(hostelId: hostelId),
    );
  }

  void _showNewNotice(
      BuildContext context, WidgetRef ref, String hostelId) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    bool pinned = false;

    DcBottomSheet.show(
      context,
      title: 'New Notice',
      child: StatefulBuilder(
        builder: (ctx, setS) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DcTextField(label: 'Title', controller: titleCtrl),
              const SizedBox(height: 10),
              DcTextField(
                  label: 'Content',
                  controller: bodyCtrl,
                  maxLines: 4),
              const SizedBox(height: 8),
              SwitchListTile(
                value: pinned,
                onChanged: (v) => setS(() => pinned = v),
                title: const Text('Pin notice',
                    style: TextStyle(fontSize: 14)),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              DcButton(
                label: 'Post',
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    await ref.read(broadcastApiProvider).createNotice({
                      'title': titleCtrl.text.trim(),
                      'body': bodyCtrl.text.trim(),
                      'hostel_id': hostelId,
                      'is_pinned': pinned,
                    });
                    ref.invalidate(_noticesProvider(hostelId));
                    if (context.mounted) {
                      DcSnackbar.success(context, 'Notice posted');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      DcSnackbar.error(context, e.toString());
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final String hostelId;
  const _Body({required this.hostelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_noticesProvider(hostelId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(_noticesProvider(hostelId))),
      data: (list) {
        if (list.isEmpty) {
          return const DcEmptyState(
              icon: Icons.description_outlined,
              title: 'No notices yet');
        }
        final pinned = list.where((n) => n.isPinned).toList();
        final rest = list.where((n) => !n.isPinned).toList();
        final ordered = [...pinned, ...rest];

        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(_noticesProvider(hostelId)),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: ordered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) =>
                _NoticeCard(notice: ordered[i], hostelId: hostelId),
          ),
        );
      },
    );
  }
}

class _NoticeCard extends ConsumerWidget {
  final Notice notice;
  final String hostelId;
  const _NoticeCard(
      {required this.notice, required this.hostelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.4,
        children: [
          SlidableAction(
            onPressed: (_) => _togglePin(context, ref),
            backgroundColor:
                notice.isPinned ? AppColors.textSecondary : AppColors.warning,
            foregroundColor: Colors.white,
            icon: notice.isPinned
                ? Icons.push_pin_outlined
                : Icons.push_pin_rounded,
            label: notice.isPinned ? 'Unpin' : 'Pin',
          ),
          SlidableAction(
            onPressed: (_) => _delete(context, ref),
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: DcCard(
        child: Row(children: [
          if (notice.isPinned)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.push_pin_rounded,
                  size: 14, color: AppColors.warning),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notice.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                Text(notice.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.4)),
                const SizedBox(height: 4),
                Text(
                  '${notice.postedByName}  ·  ${notice.createdAt?.formatted ?? ''}',
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 11),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _togglePin(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(broadcastApiProvider).togglePin(notice.id);
      ref.invalidate(_noticesProvider(hostelId));
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete notice?'),
        content: Text(
            'This will permanently delete "${notice.title}".'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ref.read(broadcastApiProvider).deleteNotice(notice.id);
      ref.invalidate(_noticesProvider(hostelId));
      if (context.mounted) {
        DcSnackbar.success(context, 'Notice deleted');
      }
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }
}
