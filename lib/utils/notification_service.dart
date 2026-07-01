import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/habit.dart';
import 'utils.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const int _slotsPerRoutine = 30;

  bool _initialized = false;

  Future<void> init() async {
    if (kIsWeb) return;

    try {
      tz.initializeTimeZones();
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      await _plugin.initialize(
        settings: const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
      );

      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      _initialized = true;
    } catch (_) {
      // Notifications unavailable - run silently
    }
  }

  Future<void> scheduleRoutine(Habit routine) async {
    if (!_initialized) return;
    if (!routine.isRoutine) return;
    final interval = routine.intervalMinutes;
    final startMins = routine.notificationStartMinutes;
    if (interval == null || interval <= 0 || startMins == null) return;

    final now = tz.TZDateTime.now(tz.local);

    final anchor = tz.TZDateTime(
      tz.local,
      routine.created.year,
      routine.created.month,
      routine.created.day,
      startMins ~/ 60,
      startMins % 60,
    );

    tz.TZDateTime nextSlot = anchor;
    if (nextSlot.isBefore(now)) {
      final elapsed = now.difference(anchor);
      final steps = (elapsed.inMinutes / interval).ceil();
      nextSlot = anchor.add(Duration(minutes: steps * interval));
    }

    final routineKey = routine.key as int;
    final details = _notificationDetails(routine);

    try {
      for (int i = 0; i < _slotsPerRoutine; i++) {
        final slot = nextSlot.add(Duration(minutes: i * interval));
        if (slot.isBefore(now)) continue;

        final id = _notifId(routineKey, i);
        await _plugin.zonedSchedule(
          id: id,
          title: routine.name,
          body: _body(interval),
          scheduledDate: slot,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (_) {
      // Platform channels unavailable - run silently.
    }
  }

  Future<void> cancelRoutine(Habit routine) async {
    if (!_initialized) return;
    final routineKey = routine.key as int;
    try {
      for (int i = 0; i < _slotsPerRoutine; i++) {
        await _plugin.cancel(id: _notifId(routineKey, i));
      }
    } catch (_) {}
  }

  Future<void> rescheduleAll(List<Habit> routines) async {
    if (!_initialized) return;
    try {
      await _plugin.cancelAll();
    } catch (_) {}
    for (final r in routines) {
      await scheduleRoutine(r);
    }
  }

  int _notifId(int routineKey, int offset) => routineKey * 100 + offset;

  String _body(int intervalMinutes) {
    return 'Every ${formatDuration(Duration(minutes: intervalMinutes))}';
  }

  NotificationDetails _notificationDetails(Habit routine) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'routines_channel',
        'Routines',
        channelDescription: 'Reminders for your routines',
        importance: Importance.high,
        priority: Priority.high,
        color: routine.color,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }
}
