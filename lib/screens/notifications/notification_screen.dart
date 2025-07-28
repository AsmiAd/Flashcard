// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';

// import '../../core/constants/app_text_styles.dart';
// import '../../providers/notification_provider.dart';


// class NotificationScreen extends ConsumerWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final unreadCountAsync = ref.watch(notificationProvider);

//     // We also want the full notifications list from NotificationService, so:
//     final notificationService = ref.read(notificationServiceProvider);

//     // Since Hive data is synchronous, we can get notifications directly
//     final notifications = notificationService.getAllNotifications();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.done_all),
//             onPressed: () async {
//               await notificationService.markAllRead();
//               ref.invalidate(notificationProvider);
//             },
//             tooltip: "Mark all as read",
//           )
//         ],
//       ),
//       body: notifications.isEmpty
//           ? const Center(child: Text('No notifications'))
//           : ListView.separated(
//               padding: const EdgeInsets.all(16),
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemCount: notifications.length,
//               itemBuilder: (_, i) {
//                 final notif = notifications[i];
//                 final date = DateTime.parse(notif['timestamp'] as String);
//                 final read = notif['read'] == true;

//                 return ListTile(
//                   tileColor: read ? Colors.grey[100] : Colors.blue[50],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   title: Text(
//                     notif['title'] ?? '',
//                     style: AppTextStyles.bodyMedium.copyWith(
//                       fontWeight: read ? FontWeight.normal : FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     notif['message'] ?? '',
//                     style: AppTextStyles.bodySmall,
//                   ),
//                   trailing: Text(
//                     DateFormat('MMM d, h:mm a').format(date),
//                     style: const TextStyle(fontSize: 11),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
