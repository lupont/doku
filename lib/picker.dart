import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final bool enabled;
  final Function(int?) onTap;

  const Picker({
    Key? key,
    required this.enabled,
    required this.onTap,
  }) : super(key: key);

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  @override
  Widget build(BuildContext context) {
    Color color = widget.enabled ? Colors.black : Colors.grey;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [null, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((index) {
        return GestureDetector(
          child: PickerCell(num: index, color: color),
          onTap: () {
            if (widget.enabled) {
              widget.onTap(index);
            }
          },
        );
      }).toList(),
    );
  }
}

class PickerCell extends StatefulWidget {
  final Color color;
  final int? num;

  const PickerCell({
    Key? key,
    required this.num,
    required this.color,
  }) : super(key: key);

  @override
  State<PickerCell> createState() => _PickerCellState();
}

class _PickerCellState extends State<PickerCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: widget.color,
        ),
      ),
      width: 40,
      height: 40,
      child: Text(
        widget.num == null ? "" : widget.num.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32,
          color: widget.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
