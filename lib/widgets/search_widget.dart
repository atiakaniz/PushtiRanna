import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String) onChanged;

  const SearchWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search recipes...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}