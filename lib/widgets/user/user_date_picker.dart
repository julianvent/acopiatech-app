import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class UserDatePicker extends StatefulWidget {
  final void Function(DateTime)? onDateSelected;
  final DateTime earliestSelectableDate;

  const UserDatePicker({
    super.key,
    this.onDateSelected,
    required this.earliestSelectableDate,
  });

  @override
  State<UserDatePicker> createState() => _UserDatePickerState();
}

class _UserDatePickerState extends State<UserDatePicker> {
  late DateTime selectedDate;

  @override
  void initState() {
    selectedDate = widget.earliestSelectableDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      if (selectedDay.isAfter(widget.earliestSelectableDate)) {
        setState(() {
          selectedDate = selectedDay;
        });
        widget.onDateSelected?.call(selectedDate);
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
          color: Colors.black,
        ),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      enabledDayPredicate: (day) {
        return (day.weekday != DateTime.sunday &&
            day.weekday != DateTime.saturday);
      },
      currentDay: widget.earliestSelectableDate,
      focusedDay: selectedDate,
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      onDaySelected: onDaySelected,
      firstDay: DateTime.utc(2024, 12, 25),
      lastDay: DateTime.utc(2079, 12, 31),
    );
  }
}
