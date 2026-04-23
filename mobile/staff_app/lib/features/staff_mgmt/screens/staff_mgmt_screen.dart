import 'package:dormconnect_core/dormconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final _staffListProvider =
    FutureProvider.autoDispose<List<User>>((ref) async {
  final resp = await ref
      .watch(apiClientProvider)
      .get('/api/v1/staff', params: {'limit': 100});
  return (resp.data as List<dynamic>)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList();
});

class StaffMgmtScreen extends ConsumerStatefulWidget {
  const StaffMgmtScreen({super.key});

  @override
  ConsumerState<StaffMgmtScreen> createState() =>
      _StaffMgmtScreenState();
}

class _StaffMgmtScreenState extends ConsumerState<StaffMgmtScreen> {
  String _search = '';
  UserRole? _roleFilter;

  static const _staffRoles = [
    UserRole.caretaker,
    UserRole.asstWarden,
    UserRole.warden,
    UserRole.asstChiefWarden,
    UserRole.guard,
  ];

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_staffListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_staffListProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showInviteStaff(context),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Invite Staff'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search by name…',
              prefixIcon: Icon(Icons.search_rounded, size: 18),
              isDense: true,
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),

        // Role filter chips
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _roleFilter == null,
                  selectedColor: AppColors.primary.withOpacity(0.15),
                  onSelected: (_) =>
                      setState(() => _roleFilter = null),
                ),
              ),
              ..._staffRoles.map((r) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(r.displayName),
                      selected: _roleFilter == r,
                      selectedColor:
                          AppColors.primary.withOpacity(0.15),
                      onSelected: (_) =>
                          setState(() => _roleFilter = r),
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 4),

        Expanded(
          child: async.when(
            loading: () => const DcLoading(),
            error: (e, _) => DcErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(_staffListProvider)),
            data: (all) {
              final filtered = all.where((s) {
                final matchSearch = _search.isEmpty ||
                    s.name
                        .toLowerCase()
                        .contains(_search.toLowerCase());
                final matchRole =
                    _roleFilter == null || s.role == _roleFilter;
                return matchSearch && matchRole;
              }).toList();

              if (filtered.isEmpty) {
                return const DcEmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'No staff found');
              }

              return RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(_staffListProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                  itemBuilder: (_, i) =>
                      _StaffCard(user: filtered[i]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  void _showInviteStaff(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    UserRole selectedRole = UserRole.caretaker;

    DcBottomSheet.show(
      context,
      title: 'Invite Staff',
      child: StatefulBuilder(
        builder: (ctx, setS) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DcTextField(label: 'Full Name', controller: nameCtrl),
              const SizedBox(height: 8),
              DcTextField(
                label: 'Phone',
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              DcTextField(
                label: 'Email (optional)',
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Role',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _staffRoles
                    .map((r) => ChoiceChip(
                          label: Text(r.displayName,
                              style:
                                  const TextStyle(fontSize: 12)),
                          selected: selectedRole == r,
                          selectedColor:
                              AppColors.primary.withOpacity(0.15),
                          onSelected: (_) =>
                              setS(() => selectedRole = r),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              DcButton(
                label: 'Send Invite',
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    await ref.read(apiClientProvider).post(
                      '/api/v1/staff/invite',
                      data: {
                        'name': nameCtrl.text.trim(),
                        'phone': phoneCtrl.text.trim(),
                        if (emailCtrl.text.trim().isNotEmpty)
                          'email': emailCtrl.text.trim(),
                        'role': selectedRole.name,
                      },
                    );
                    ref.invalidate(_staffListProvider);
                    if (context.mounted) {
                      DcSnackbar.success(context, 'Invite sent');
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

class _StaffCard extends ConsumerWidget {
  final User user;
  const _StaffCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => _toggleActive(context, ref),
            backgroundColor: user.isActive
                ? AppColors.textSecondary
                : AppColors.success,
            foregroundColor: Colors.white,
            icon: user.isActive
                ? Icons.block_rounded
                : Icons.check_circle_outline,
            label: user.isActive ? 'Deactivate' : 'Activate',
          ),
        ],
      ),
      child: DcCard(
        child: Row(children: [
          DcAvatar(
            name: user.name,
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  if (!user.isActive) ...[
                    const SizedBox(width: 6),
                    DcStatusChip(status: 'inactive'),
                  ],
                ]),
                Text(user.role.displayName,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12)),
                Text(user.phone,
                    style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textTertiary, size: 16),
        ]),
      ),
    );
  }

  Future<void> _toggleActive(
      BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(apiClientProvider).patch(
        '/api/v1/staff/${user.id}',
        data: {'is_active': !user.isActive},
      );
      ref.invalidate(_staffListProvider);
      if (context.mounted) {
        DcSnackbar.success(
            context,
            user.isActive
                ? '${user.name} deactivated'
                : '${user.name} activated');
      }
    } catch (e) {
      if (context.mounted) DcSnackbar.error(context, e.toString());
    }
  }
}
