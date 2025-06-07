import 'package:flutter/material.dart';
import 'package:myexpensesapp/models/type_account.dart';

class CustomDropdown<T> extends StatelessWidget {

  final List<T> items;
  final T? selectedItem;
  final String? hintText;
  final Function(T?)? onChanged;

  const CustomDropdown({
    super.key, 
    required this.items,
    this.selectedItem,
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<T>(
        value: selectedItem,
        items: items.map((T item) {
          final itemName = item is TypeAccount ? item.name : item.toString();
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemName!),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
            filled: false,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            hintText: hintText,
          ),
        ),
    );
  }
}