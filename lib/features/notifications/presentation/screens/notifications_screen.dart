import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/localization/app_localizations.dart';

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final String timeAgo;
  bool isNew;
  final String dateCategory; // "today" or "yesterday"

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isNew = true,
    required this.dateCategory,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // بيانات وهمية للإشعارات باستخدام مفاتيح الترجمة
  List<NotificationItem> notifications = [
    NotificationItem(id: '1', type: 'notification_type_promo', title: 'notification_title_1', description: 'notification_desc_1', timeAgo: 'time_2h_ago', dateCategory: 'today', isNew: true),
    NotificationItem(id: '2', type: 'notification_type_order', title: 'notification_title_2', description: 'notification_desc_2', timeAgo: 'time_4h_ago', dateCategory: 'today', isNew: true),
    NotificationItem(id: '3', type: 'notification_type_admin', title: 'notification_title_3', description: 'notification_desc_3', timeAgo: 'time_8h_ago', dateCategory: 'today', isNew: true),
    NotificationItem(id: '4', type: 'notification_type_promo', title: 'notification_title_4', description: 'notification_desc_4', timeAgo: 'time_10h_ago', dateCategory: 'today', isNew: false),
    NotificationItem(id: '5', type: 'notification_type_remind', title: 'notification_title_5', description: 'notification_desc_5', timeAgo: 'time_yesterday_morning', dateCategory: 'yesterday', isNew: false),
    NotificationItem(id: '6', type: 'notification_type_welcome', title: 'notification_title_6', description: 'notification_desc_6', timeAgo: 'time_yesterday_early', dateCategory: 'yesterday', isNew: false),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var note in notifications) {
        note.isNew = false;
      }
    });
  }

  void _removeNotification(String id) {
    setState(() {
      notifications.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // تجميع الإشعارات حسب التاريخ
    final todayNotifications = notifications.where((n) => n.dateCategory == 'today').toList();
    final yesterdayNotifications = notifications.where((n) => n.dateCategory == 'yesterday').toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Light background
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _NotificationsHeader(
            onMarkAllAsRead: notifications.any((n) => n.isNew) ? _markAllAsRead : null,
          ),

          // List of notifications
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.notification_bing, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          context.tr('no_notifications'), 
                          style: GoogleFonts.cairo(
                            fontSize: 18, 
                            color: Colors.grey.shade500, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    children: [
                      if (todayNotifications.isNotEmpty) ...[
                        _buildSectionTitle(context.tr("today")),
                        const SizedBox(height: 10),
                        ...todayNotifications.map((n) => _buildNotificationCard(n)),
                        const SizedBox(height: 20),
                      ],
                      if (yesterdayNotifications.isNotEmpty) ...[
                        _buildSectionTitle(context.tr("yesterday")),
                        const SizedBox(height: 10),
                        ...yesterdayNotifications.map((n) => _buildNotificationCard(n)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _removeNotification(item.id);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Iconsax.trash, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          if (item.isNew) {
            setState(() {
              item.isNew = false;
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: item.isNew ? Theme.of(context).cardColor : (isDark ? const Color(0xFF181818) : const Color(0xFFFDFDFD)),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black38 : Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            // The red side bar matching layout direction
            border: item.isNew
                ? Border(
                    right: isAr
                        ? const BorderSide(color: Color(0xFF7D4E44), width: 3)
                        : BorderSide.none,
                    left: !isAr
                        ? const BorderSide(color: Color(0xFF7D4E44), width: 3)
                        : BorderSide.none,
                  )
                : Border.all(color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: item.isNew 
                        ? (isDark ? const Color(0xFF2C2220) : const Color(0xFFF1E4E0)) 
                        : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF0F0F0)),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isNew ? Iconsax.notification5 : Iconsax.notification,
                    color: item.isNew ? (isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)) : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr(item.type),
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        context.tr(item.title),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: item.isNew ? FontWeight.bold : FontWeight.w600,
                          color: isDark ? Colors.white : (item.isNew ? Colors.black : Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.tr(item.description),
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Time
                Text(
                  context.tr(item.timeAgo),
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Header for Notifications ---
class _NotificationsHeader extends StatelessWidget {
  final VoidCallback? onMarkAllAsRead;
  
  const _NotificationsHeader({this.onMarkAllAsRead});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF3E2D2A), const Color(0xFF301F1C)] 
              : [const Color(0xFFCCB6B3), const Color(0xFFC39088)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // العنوان وزر الرجوع (على البداية)
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(
                    isAr ? Iconsax.arrow_right_1 : Iconsax.arrow_left_2,
                    color: isDark ? Colors.white : const Color(0xFF572F29),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  context.tr("notifications"),
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF572F29),
                  ),
                ),
              ],
            ),

            // زر قراءة الكل (على النهاية)
            if (onMarkAllAsRead != null)
              GestureDetector(
                onTap: onMarkAllAsRead,
                child: Row(
                  children: [
                    Icon(Iconsax.tick_square, size: 16, color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D)),
                    const SizedBox(width: 4),
                    Text(
                      context.tr("mark_as_read"),
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFC39088) : const Color(0xFF99574D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(width: 80), // Placeholder
          ],
        ),
      ),
    );
  }
}
