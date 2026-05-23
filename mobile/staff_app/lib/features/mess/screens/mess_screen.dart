import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _messMenuProvider =
    FutureProvider.autoDispose.family<List<MessMenu>, String>(
        (ref, hostelId) async =>
            ref.watch(messApiProvider).getMenu(hostelId));

final _messOffsProvider =
    FutureProvider.autoDispose.family<List<MessOff>, String>(
        (ref, hostelId) async =>
            ref.watch(messApiProvider).getMessOffs(hostelId));

class MessScreen extends ConsumerStatefulWidget {
  const MessScreen({super.key});

  @override
  ConsumerState<MessScreen> createState() => _MessScreenState();
}

class _MessScreenState extends ConsumerState<MessScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final hostelId = user?.hostelId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(_messMenuProvider(hostelId));
              ref.invalidate(_messOffsProvider(hostelId));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.secondary,
          tabs: const [
            Tab(text: "Today's Menu"),
            Tab(text: 'Mess-Off'),
          ],
        ),
      ),
      floatingActionButton: _tab.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _showPostMenu(context, hostelId),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Post Menu'),
              backgroundColor: AppColors.primary,
            )
          : null,
      body: TabBarView(
        controller: _tab,
        children: [
          _MenuTab(hostelId: hostelId),
          _MessOffTab(hostelId: hostelId),
        ],
      ),
    );
  }

  void _showPostMenu(BuildContext context, String hostelId) {
    final breakfastCtrl = TextEditingController();
    final lunchCtrl = TextEditingController();
    final snacksCtrl = TextEditingController();
    final dinnerCtrl = TextEditingController();

    DcBottomSheet.show(
      context,
      title: "Post Today's Menu",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DcTextField(
                label: 'Breakfast', controller: breakfastCtrl),
            const SizedBox(height: 8),
            DcTextField(label: 'Lunch', controller: lunchCtrl),
            const SizedBox(height: 8),
            DcTextField(label: 'Snacks', controller: snacksCtrl),
            const SizedBox(height: 8),
            DcTextField(label: 'Dinner', controller: dinnerCtrl),
            const SizedBox(height: 16),
            DcButton(
              label: 'Post',
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final today =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  await ref.read(messApiProvider).postMenu({
                    'hostel_id': hostelId,
                    'date': today,
                    'breakfast': breakfastCtrl.text.trim(),
                    'lunch': lunchCtrl.text.trim(),
                    'snacks': snacksCtrl.text.trim(),
                    'dinner': dinnerCtrl.text.trim(),
                  });
                  ref.invalidate(_messMenuProvider(hostelId));
                  if (context.mounted) {
                    DcSnackbar.success(context, 'Menu posted');
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
    );
  }
}

class _MenuTab extends ConsumerWidget {
  final String hostelId;
  const _MenuTab({required this.hostelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_messMenuProvider(hostelId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(_messMenuProvider(hostelId))),
      data: (menus) {
        if (menus.isEmpty) {
          return const DcEmptyState(
              icon: Icons.restaurant_outlined,
              title: 'No menu posted yet');
        }

        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final todayMenu =
            menus.where((m) => m.date == today).firstOrNull;
        final otherMenus =
            menus.where((m) => m.date != today).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (todayMenu != null) ...[
              const Text("Today's Menu",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 8),
              _MenuCard(menu: todayMenu, highlight: true),
              const SizedBox(height: 20),
            ],
            if (otherMenus.isNotEmpty) ...[
              const Text('Past / Upcoming',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 8),
              ...otherMenus
                  .map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MenuCard(menu: m, highlight: false),
                      ))
                  ,
            ],
          ],
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MessMenu menu;
  final bool highlight;
  const _MenuCard({required this.menu, required this.highlight});

  @override
  Widget build(BuildContext context) {
    DateTime? dt;
    try {
      dt = DateFormat('yyyy-MM-dd').parse(menu.date);
    } catch (_) {}

    return DcCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.calendar_today_outlined,
                size: 14,
                color: highlight
                    ? AppColors.primary
                    : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              dt != null
                  ? DateFormat('EEEE, dd MMM').format(dt)
                  : menu.date,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: highlight
                      ? AppColors.primary
                      : AppColors.textPrimary),
            ),
            if (menu.postedByName != null) ...[
              const Spacer(),
              Text(menu.postedByName!,
                  style: const TextStyle(
                      color: AppColors.textTertiary, fontSize: 11)),
            ],
          ]),
          const SizedBox(height: 10),
          ...([
            ('Breakfast', menu.breakfast, Icons.free_breakfast_outlined),
            ('Lunch', menu.lunch, Icons.lunch_dining_outlined),
            ('Snacks', menu.snacks, Icons.cookie_outlined),
            ('Dinner', menu.dinner, Icons.dinner_dining_outlined),
          ]
              .where((e) => e.$2 != null)
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(e.$3,
                              size: 14,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 64,
                            child: Text(e.$1,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ),
                          Expanded(
                            child: Text(e.$2!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ]),
                  ))),
        ],
      ),
    );
  }
}

class _MessOffTab extends ConsumerWidget {
  final String hostelId;
  const _MessOffTab({required this.hostelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_messOffsProvider(hostelId));
    return async.when(
      loading: () => const DcLoading(),
      error: (e, _) => DcErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(_messOffsProvider(hostelId))),
      data: (offs) {
        if (offs.isEmpty) {
          return const DcEmptyState(
              icon: Icons.no_meals_outlined,
              title: 'No mess-off requests');
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(_messOffsProvider(hostelId)),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: offs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final off = offs[i];
              return DcCard(
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (off.isApproved
                              ? AppColors.success
                              : AppColors.warning)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.no_meals_outlined,
                        color: off.isApproved
                            ? AppColors.success
                            : AppColors.warning,
                        size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat('dd MMM').format(off.fromDate)} – ${DateFormat('dd MMM').format(off.toDate)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        if (off.reason != null)
                          Text(off.reason!,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                      ],
                    ),
                  ),
                  DcStatusChip(
                      status: off.isApproved ? 'approved' : 'pending'),
                ]),
              );
            },
          ),
        );
      },
    );
  }
}
