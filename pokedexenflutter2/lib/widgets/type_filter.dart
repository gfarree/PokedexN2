import 'package:flutter/material.dart';

class TypeFilter extends StatelessWidget {
  final List<String> types;
  final Function(String) onSelectType;

  const TypeFilter({super.key, required this.types, required this.onSelectType});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: types.map((type) {
        return ElevatedButton(
          onPressed: () => onSelectType(type),
          child: Text(type),
        );
      }).toList(),
    );
  }
}