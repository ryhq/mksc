import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/home/home_widget/category_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final String svgicon;
  final int localData;

  const CategoryCard({super.key, required this.title, required this.svgicon, required this.localData});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (
          widget.title == "Chicken House" || 
          widget.title == "Menu" || 
          widget.title == "Vegetables" || 
          widget.title == "Laundry"
        ) {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context, 
            builder: (BuildContext context) {
              return CategoryBottomSheet(title: widget.title,);
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: "Sorry ${widget.title} not available for now",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );          
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary,
              // Colors.blue,
              // Color.fromARGB(255, 154, 192, 224),
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    widget.svgicon,
                    height: 40,
                    width: 40,
                    theme: const SvgTheme(currentColor: Colors.white),
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Opacity(
                opacity: widget.localData > 0 ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(21))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        widget.localData > 0 && widget.localData <10 ? "0${widget.localData}": "${widget.localData}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: Provider.of<ThemeProvider>(context).fontSize * 0.754
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}