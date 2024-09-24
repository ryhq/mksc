
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  String svgUrl = "";
  @override
  Widget build(BuildContext context) {
    if (widget.title.startsWith('cock')) {
      setState(() {
        svgUrl = "assets/icons/chicken_.svg";
      });
    }
    if (widget.title.startsWith('hen')) {
      setState(() {
        svgUrl = "assets/icons/hen.svg";
      });
    }
    if (widget.title.startsWith('chick')) {
      setState(() {
        svgUrl = "assets/icons/chick.svg";
      });      
    }
    if (widget.title.startsWith('egg')) {
      setState(() {
        svgUrl = "assets/icons/egg.svg";
      });         
    }
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                svgUrl,
                height: 20,
                width: 20,
                theme: const SvgTheme(currentColor: Colors.white),
                color: Colors.white,
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