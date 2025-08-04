import 'package:flutter/material.dart';

class NumberStepper extends StatefulWidget {
  final int? value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String? label;

  const NumberStepper({
    super.key,
    this.value,
    this.min = 0,
    this.max = 150,
    required this.onChanged,
    this.label,
  });

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? widget.min;
  }

  @override
  void didUpdateWidget(NumberStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _currentValue) {
      _currentValue = widget.value!;
    }
  }

  void _increment() {
    if (_currentValue < widget.max) {
      setState(() {
        _currentValue++;
      });
      widget.onChanged(_currentValue);
    }
  }

  void _decrement() {
    if (_currentValue > widget.min) {
      setState(() {
        _currentValue--;
      });
      widget.onChanged(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _currentValue > widget.min ? _decrement : null,
                icon: const Icon(Icons.remove),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 60),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  _currentValue.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: _currentValue < widget.max ? _increment : null,
                icon: const Icon(Icons.add),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
