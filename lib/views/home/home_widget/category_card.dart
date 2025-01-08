import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/views/authentication/authentication_page.dart';
import 'package:mksc/views/menu/widgets/menu_content_bottom_sheet.dart';
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
        _showModalBottomSheet(context);
      },
      child: Card(
        elevation: Provider.of<ThemeProvider>(context).fontSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the size of the SVG based on the card's width or height
              double svgSize = constraints.maxWidth * 0.3; // Adjust the factor as needed
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          widget.svgicon,
                          height: svgSize,
                          width: svgSize,
                          theme: const SvgTheme(currentColor: Colors.white),
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    if (
      widget.title == "Chicken House" || 
      widget.title == "Vegetables" || 
      widget.title == "Laundry"
    ) {

      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Adjust for dynamic height
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
        ),
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        size: Provider.of<ThemeProvider>(context).fontSize + 7,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text("Data"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationPage(title: widget.title),));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.grade,
                        size: Provider.of<ThemeProvider>(context).fontSize + 7,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text("Consult"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else if (widget.title == "Menu") {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Adjust for dynamic height
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
        ),
        builder: (BuildContext context) {
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
            child: const Padding(
              padding: EdgeInsets.only(top: 28.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MenuContentBottomSheet()
                  ]
                ),
              ),
            ),
          );
        },
      );
    } else {
      if (!kIsWeb && Platform.isLinux){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Sorry ${widget.title} not available for now", 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white
              ),
            ),
            backgroundColor: Colors.red,
          )
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
    }
  }
}