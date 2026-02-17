import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mango/core/theme/app_colors.dart';
import 'package:mango/core/theme/app_typography.dart';

/// A custom, premium time picker for the Mango app
class MangoTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const MangoTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<MangoTimePicker> createState() => _MangoTimePickerState();

  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) async {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _TimePickerSheet(initialTime: initialTime),
    );
  }
}

class _MangoTimePickerState extends State<MangoTimePicker> {
  late int selectedHourIndex; // 0-11 for 1-12
  late int selectedMinute;
  late int selectedPeriodIndex; // 0 for AM, 1 for PM

  @override
  void initState() {
    super.initState();
    final hour = widget.initialTime.hourOfPeriod;
    selectedHourIndex = (hour == 0 ? 12 : hour) - 1;
    selectedMinute = widget.initialTime.minute;
    selectedPeriodIndex = widget.initialTime.period == DayPeriod.am ? 0 : 1;
  }

  void _updateTime() {
    int hour = selectedHourIndex + 1;
    if (selectedPeriodIndex == 0) {
      if (hour == 12) hour = 0;
    } else {
      if (hour != 12) hour += 12;
    }
    widget.onTimeChanged(TimeOfDay(hour: hour, minute: selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Wheel (1-12)
                _buildPickerWheel(
                  width: 70,
                  itemCount: 12,
                  initialItem: selectedHourIndex,
                  onSelectedItemChanged: (index) {
                    setState(() => selectedHourIndex = index);
                    _updateTime();
                  },
                  labelBuilder:
                      (index) => (index + 1).toString().padLeft(2, '0'),
                ),

                Text(
                  ':',
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.accent,
                    fontSize: 24,
                  ),
                ),

                // Minute Wheel (00-59)
                _buildPickerWheel(
                  width: 70,
                  itemCount: 60,
                  initialItem: selectedMinute,
                  onSelectedItemChanged: (index) {
                    setState(() => selectedMinute = index);
                    _updateTime();
                  },
                  labelBuilder: (index) => index.toString().padLeft(2, '0'),
                ),

                const SizedBox(width: 12),

                // AM/PM Wheel
                _buildPickerWheel(
                  width: 70,
                  itemCount: 2,
                  initialItem: selectedPeriodIndex,
                  onSelectedItemChanged: (index) {
                    setState(() => selectedPeriodIndex = index);
                    _updateTime();
                  },
                  labelBuilder: (index) => index == 0 ? 'AM' : 'PM',
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerWheel({
    required double width,
    required int itemCount,
    required int initialItem,
    required ValueChanged<int> onSelectedItemChanged,
    required String Function(int) labelBuilder,
    double fontSize = 28,
  }) {
    return SizedBox(
      width: width,
      child: CupertinoPicker.builder(
        itemExtent: 50,
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        onSelectedItemChanged: onSelectedItemChanged,
        childCount: itemCount,
        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          background: Colors.transparent,
          capStartEdge: false,
          capEndEdge: false,
        ),
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              labelBuilder(index),
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimary,
                fontFamily: 'serif',
                fontSize: fontSize,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimePickerSheet extends StatefulWidget {
  final TimeOfDay initialTime;

  const _TimePickerSheet({required this.initialTime});

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Text(
            'SELECT TIME',
            style: AppTypography.labelSmall.copyWith(
              letterSpacing: 2,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: MangoTimePicker(
              initialTime: _time,
              onTimeChanged: (newTime) {
                _time = newTime;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _time),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleMask(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedRectangleMask extends RoundedRectangleBorder {
  const RoundedRectangleMask({super.borderRadius});
}
