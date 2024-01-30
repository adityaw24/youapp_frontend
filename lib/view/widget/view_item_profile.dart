import 'package:flutter/material.dart';

class ViewItemProfile extends StatelessWidget {
  const ViewItemProfile({
    super.key,
    required this.label,
    this.colorLabel,
    this.colorValue,
    this.value,
  });

  final Color? colorLabel;
  final Color? colorValue;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label :',
            style: TextStyle(
              color: colorLabel,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            value == null ? '-' : value!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
