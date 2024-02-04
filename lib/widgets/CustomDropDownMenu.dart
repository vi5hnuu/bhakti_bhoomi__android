import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final String initialSelection;
  final ValueChanged<String?>? onSelected;
  final String label;
  final List<DropdownMenuEntry<String>> dropdownMenuEntries;
  const CustomDropDownMenu({super.key, required this.label, required this.initialSelection, required this.onSelected, required this.dropdownMenuEntries});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: MediaQuery.of(context).size.width - 25,
      label: Text(this.label, style: TextStyle(color: Theme.of(context).primaryColor)),
      textStyle: TextStyle(color: Theme.of(context).primaryColor),
      leadingIcon: Icon(Icons.translate, color: Theme.of(context).primaryColor),
      menuStyle: MenuStyle(
        surfaceTintColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(side: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5))),
      ),
      inputDecorationTheme: InputDecorationTheme(suffixIconColor: Theme.of(context).primaryColor, enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      enableSearch: true,
      dropdownMenuEntries: this.dropdownMenuEntries,
      initialSelection: this.initialSelection,
      onSelected: this.onSelected,
    );
  }
}

DropdownMenuEntry<String> CustomDropDownEntry({required String label, required String value, required foreGroundColor}) {
  return DropdownMenuEntry(value: value, label: label, style: ButtonStyle(foregroundColor: MaterialStateProperty.all(foreGroundColor)));
}
