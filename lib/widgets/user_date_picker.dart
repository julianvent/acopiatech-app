import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class UserDatePicker extends StatefulWidget {
  const UserDatePicker({super.key});

  @override
  State<UserDatePicker> createState() => _UserDatePickerState();
}

class _UserDatePickerState extends State<UserDatePicker> {
  DateTime earliestSelectableDate = DateTime.now().add(const Duration(days: 2));
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));

  @override
  Widget build(BuildContext context) {
    void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      if (selectedDay.isAfter(earliestSelectableDate) ||
          isSameDay(selectedDay, earliestSelectableDate)) {
        setState(() {
          _selectedDate = selectedDay;
        });
      }
    }

    return TableCalendar(
      locale: 'es_ES',
      rowHeight: 50,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      currentDay: earliestSelectableDate,
      focusedDay: _selectedDate,
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
      onDaySelected: _onDaySelected,
      firstDay: DateTime.utc(2024, 12, 25),
      lastDay: DateTime.utc(2079, 12, 31),
    );
  }
}
