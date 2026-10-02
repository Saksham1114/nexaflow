import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../models/habit.dart';
import '../../providers/habit_provider.dart';
import '../../utils/habit_icon_helper.dart';

class AddHabitBottomSheet extends ConsumerStatefulWidget {
  const AddHabitBottomSheet({super.key, this.habitToEdit});

  final Habit? habitToEdit;

  @override
  ConsumerState<AddHabitBottomSheet> createState() =>
      _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends ConsumerState<AddHabitBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  late HabitFrequency _frequency;
  late String _selectedIcon;
  late int _selectedColor;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    final edit = widget.habitToEdit;
    _titleController = TextEditingController(text: edit?.title ?? '');
    _frequency = edit?.frequency ?? HabitFrequency.daily;
    _selectedIcon = edit?.iconName ?? 'star';
    _selectedColor = edit?.colorValue ?? HabitIconHelper.presetColors[0];

    if (edit?.reminderTime != null) {
      final parts = edit!.reminderTime!.split(':');
      if (parts.length == 2) {
        _reminderTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    final formattedReminder = _reminderTime != null
        ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
        : null;

    final habitId = widget.habitToEdit?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final habit = Habit(
      id: habitId,
      title: _titleController.text.trim(),
      frequency: _frequency,
      completedToday: widget.habitToEdit?.completedToday ?? false,
      createdAt: widget.habitToEdit?.createdAt ?? DateTime.now(),
      lastCompletedDate: widget.habitToEdit?.lastCompletedDate,
      iconName: _selectedIcon,
      colorValue: _selectedColor,
      reminderTime: formattedReminder,
    );

    if (widget.habitToEdit != null) {
      await ref.read(habitProvider.notifier).update(habit);
    } else {
      await ref.read(habitProvider.notifier).add(habit);
    }

    // Schedule notification if reminder time is set
    if (_reminderTime != null) {
      final notifId = habitId.hashCode.abs() % 100000;
      await ref.read(notificationServiceProvider).scheduleDailyNotification(
            id: notifId,
            title: 'Habit Reminder ⏰',
            body: 'Time to complete your habit: "${habit.title}"',
            hour: _reminderTime!.hour,
            minute: _reminderTime!.minute,
          );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.habitToEdit != null
                ? 'Habit updated!'
                : 'Habit created successfully! 🔥',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.habitToEdit != null ? 'Edit Habit' : 'Create New Habit',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title input
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Habit Title',
                  hintText: 'e.g., Morning Meditation, Read 20 pages',
                  prefixIcon: Icon(
                    HabitIconHelper.getIcon(_selectedIcon),
                    color: Color(_selectedColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a habit title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Frequency Selector
              Text(
                'Frequency',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Daily')),
                      selected: _frequency == HabitFrequency.daily,
                      onSelected: (selected) {
                        if (selected) setState(() => _frequency = HabitFrequency.daily);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Weekly')),
                      selected: _frequency == HabitFrequency.weekly,
                      onSelected: (selected) {
                        if (selected) setState(() => _frequency = HabitFrequency.weekly);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Color Palette Picker
              Text(
                'Color Theme',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: HabitIconHelper.presetColors.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final colorVal = HabitIconHelper.presetColors[index];
                    final isSelected = _selectedColor == colorVal;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = colorVal),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Color(colorVal),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: isDark ? Colors.white : Colors.black,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 22)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Icon Picker
              Text(
                'Habit Icon',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: HabitIconHelper.availableIcons.entries.map((entry) {
                  final isSelected = _selectedIcon == entry.key;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selectedIcon = entry.key),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColor).withValues(alpha: 0.2)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.black.withValues(alpha: 0.04)),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: Color(_selectedColor), width: 2)
                            : null,
                      ),
                      child: Icon(
                        entry.value,
                        color: isSelected
                            ? Color(_selectedColor)
                            : (isDark ? Colors.white70 : Colors.black54),
                        size: 24,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // Daily Reminder Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Reminder',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _reminderTime != null
                            ? 'Alarm set for ${_reminderTime!.format(context)}'
                            : 'No reminder scheduled',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (_reminderTime != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          tooltip: 'Remove reminder',
                          onPressed: () => setState(() => _reminderTime = null),
                        ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.alarm_rounded, size: 18),
                        label: Text(_reminderTime == null ? 'Set Time' : 'Change'),
                        onPressed: _pickReminderTime,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(_selectedColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveHabit,
                  child: Text(
                    widget.habitToEdit != null ? 'Save Changes' : 'Create Habit',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
