import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final ValueChanged<bool> onChange;

  const CustomCheckBox({Key? key, required this.onChange}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
                widget.onChange(isSelected);
              },
              child: AnimatedContainer(
                duration: const Duration(microseconds: 500),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF1a2d42) : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                ),
                height: 25,
                width: 25,
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Save Card for the next payment'),
          ],
        ),
      ],
    );
  }
}
