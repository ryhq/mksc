import 'package:flutter/material.dart';
import 'package:mksc/view/home/home_widget/menu_content_bottom_sheet.dart';
import 'package:mksc/view/home/home_widget/non_menu_content_bottom_sheet.dart';

class CategoryBottomSheet extends StatefulWidget {
  final String? initialSelectedCamp;
  final String? title;
  final String? selectedCampType;
  final String? selectedDay;
  final String? selectedMenu;

  const CategoryBottomSheet({
    super.key,
    this.initialSelectedCamp,
    this.title,
    this.selectedCampType,
    this.selectedDay,
    this.selectedMenu
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // Color.fromRGBO(218, 242, 250, 1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.title != "Menu" && widget.title != null) ...[
                NonMenuContentBottomSheet(
                  title: widget.title!,
                )
              ] else ...[
                const MenuContentBottomSheet()
              ]
            ],
          ),
        ),
      ),
    );
  }
}
