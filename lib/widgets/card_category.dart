
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class CardCategory extends StatefulWidget {
  final String title;
  final IconData iconData;
  final bool isSelected;
  final Function(String) onCategorySelected;
  const CardCategory({
    super.key, required this.title, required this.iconData, required this.isSelected, required this.onCategorySelected,
  });

  @override
  State<CardCategory> createState() => _CardCategoryState();
}

class _CardCategoryState extends State<CardCategory> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCategorySelected(widget.title);
      },
      child: Card(
        elevation: 3,
        color: widget.isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        shape: const  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isSelected ? Icons.check : widget.iconData,
                color: widget.isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
                size: Provider.of<ThemeProvider>(context).fontSize + 7,
              ),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: widget.isSelected ? Colors.white : Theme.of(context).colorScheme.primary),
              )
            ],
          ),
        ),
      ),
    );
  }
}