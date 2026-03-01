import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/widgets/shimmer_loading.dart';
import 'package:fanup/features/notifications/presentation/state/notification_state.dart';
import 'package:fanup/features/notifications/presentation/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModelProvider);
    final notifier = ref.read(notificationViewModelProvider.notifier);
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.poppinsSemiBold18.copyWith(color: onSurface),
        ),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: () => notifier.markAllAsRead(),
              child: Text(
                'Mark all read',
                style: AppTextStyles.poppinsSemiBold15.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: notifier.load,
        child: Builder(
          builder: (context) {
            if (state.status == NotificationStatus.loading &&
                state.items.isEmpty) {
              return const ListItemShimmer();
            }

            if (state.status == NotificationStatus.error &&
                state.items.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 140),
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 42,
                    color: onSurface.withAlpha(110),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      state.errorMessage ?? 'Failed to load notifications',
                      style: AppTextStyles.poppinsRegular16.copyWith(
                        color: onSurface.withAlpha(170),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: OutlinedButton(
                      onPressed: notifier.load,
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              );
            }

            if (state.items.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 140),
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 44,
                    color: onSurface.withAlpha(110),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'No notifications yet',
                      style: AppTextStyles.poppinsRegular16.copyWith(
                        color: onSurface.withAlpha(170),
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => notifier.markAsRead(item.id),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: item.isRead
                            ? onSurface.withAlpha(35)
                            : Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(110),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NotificationTypeIcon(type: item.type),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: AppTextStyles.poppinsSemiBold15
                                          .copyWith(color: onSurface),
                                    ),
                                  ),
                                  if (!item.isRead)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.message,
                                style: AppTextStyles.poppinsRegular15.copyWith(
                                  color: onSurface.withAlpha(185),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDate(item.createdAt),
                                style: AppTextStyles.poppinsRegular15.copyWith(
                                  color: onSurface.withAlpha(145),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    return DateFormat('d MMM yyyy, h:mm a').format(value.toLocal());
  }
}

class _NotificationTypeIcon extends StatelessWidget {
  final String type;

  const _NotificationTypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg;
    final IconData icon;
    final Color fg;

    switch (type) {
      case 'prize_credited':
        bg = isDark ? const Color(0xFF4C3A1D) : const Color(0xFFFFF1D6);
        icon = Icons.workspace_premium_rounded;
        fg = isDark ? const Color(0xFFFFD07A) : const Color(0xFF7A4A00);
        break;
      case 'match_completed':
        bg = isDark ? const Color(0xFF1D3A4F) : const Color(0xFFDFF4FF);
        icon = Icons.emoji_events_outlined;
        fg = isDark ? const Color(0xFF9ED9FF) : const Color(0xFF004D79);
        break;
      case 'contest_joined':
        bg = isDark ? const Color(0xFF1E422A) : const Color(0xFFE7FBEA);
        icon = Icons.groups_2_outlined;
        fg = isDark ? const Color(0xFFA8F0BE) : const Color(0xFF0A6A29);
        break;
      default:
        bg = Theme.of(context).colorScheme.primary.withAlpha(28);
        icon = Icons.notifications_outlined;
        fg = Theme.of(context).colorScheme.primary;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 19, color: fg),
    );
  }
}
