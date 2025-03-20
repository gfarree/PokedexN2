import 'package:flutter/material.dart';

class ToggleView extends StatelessWidget {
  final bool isGridView;
  final VoidCallback onToggle;

  const ToggleView({super.key, required this.isGridView, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isGridView ? Icons.grid_view : Icons.list),
      onPressed: onToggle,
    );
  }
}