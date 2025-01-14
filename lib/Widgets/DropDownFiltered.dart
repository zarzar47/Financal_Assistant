import 'package:flutter/material.dart';
import '../backend_API.dart';

class DropdownFiltered extends StatefulWidget {
  final Function(String?) onCategoryChanged; // Callback for selectedCategory
  final Function(String?) onSubCategoryChanged; // Callback for selectedCategory
  @override
  const DropdownFiltered(
      {super.key,
      required this.onCategoryChanged,
      required this.onSubCategoryChanged});
  @override
  _DropdownFilteredState createState() => _DropdownFilteredState();
}

class _DropdownFilteredState extends State<DropdownFiltered> {
  String? selectedCategory;
  String? selectedSubCategory;

  List<String> availableSubCategories = [];

  @override
  void initState() {
    super.initState();
    availableSubCategories =
        Categories.subCategoryLists['Food']!; // Default selection
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Dropdown: Category
        DropdownButtonFormField<String>(
          value: selectedCategory,
          hint: const Text('Select Category'),
          items: Categories.primaryCategoryLists.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
              availableSubCategories = Categories.subCategoryLists[value!]!;
            });
            widget.onCategoryChanged(value);
          },
        ),

        // Second Dropdown: Subcategory
        DropdownButtonFormField<String>(
          value: selectedSubCategory,
          hint: const Text('Select Subcategory'),
          items: availableSubCategories.map((String subCategory) {
            return DropdownMenuItem<String>(
              value: subCategory,
              child: Text(subCategory),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSubCategory = value;
            });
            widget.onSubCategoryChanged(value);
          },
        ),
      ],
    );
  }
}
