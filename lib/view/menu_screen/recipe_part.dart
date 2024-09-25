import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:provider/provider.dart';

class RecipePart extends StatefulWidget {
  final Menu menu;
  const RecipePart({super.key, required this.menu});

  @override
  State<RecipePart> createState() => _RecipeState();
}

class _RecipeState extends State<RecipePart> {
  @override
  Widget build(BuildContext context) {

    DetailedMenu detailedMenu = Provider.of<MenuProvider>(context, listen: true).detailedMenu;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if(detailedMenu.dish.recipe.toString().isNotEmpty)...[
            
              Text(
                "Recipe Details",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                  data: detailedMenu.dish.recipe,
                  style: {
                    'body': Style(color: Color.fromARGB(255, 132, 130, 130),),
                  },
                ),
              ),
              
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     constraints: BoxConstraints(
              //       minHeight: 200,
              //       minWidth: MediaQuery.of(context).size.width,
              //     ),
              //     decoration: BoxDecoration(
              //       gradient: const LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [
              //           Color.fromARGB(255, 227, 230, 233),
              //           Color.fromARGB(255, 196, 216, 233),
              //         ],
              //       ),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Html(
              //             data: detailedMenu.dish.recipe,
              //             style: {
              //               'body': Style(color: Color.fromARGB(255, 132, 130, 130)),
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],

            if(detailedMenu.dish.tableware.toString().isNotEmpty)...[
            
              Text(
                "Tableware",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                  data: detailedMenu.dish.tableware,
                  style: {
                    'body': Style(color: Color.fromARGB(255, 132, 130, 130)),
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     constraints: BoxConstraints(
              //       minHeight: 200,
              //       minWidth: MediaQuery.of(context).size.width,
              //     ),
              //     decoration: BoxDecoration(
              //       gradient: const LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [
              //           Color.fromARGB(255, 227, 230, 233),
              //           Color.fromARGB(255, 196, 216, 233),
              //         ],
              //       ),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Html(
              //             data: detailedMenu.dish.tableware,
              //             style: {
              //               'body': Style(color: Color.fromARGB(255, 132, 130, 130)),
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],

            if(detailedMenu.dish.tableware.toString().isNotEmpty)...[
            
              Text(
                "Utensils",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                  data: detailedMenu.dish.utensils,
                  style: {
                    'body': Style(color: Color.fromARGB(255, 132, 130, 130)),
                  },
                ),
              ),
            
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     constraints: BoxConstraints(
              //       minHeight: 200,
              //       minWidth: MediaQuery.of(context).size.width,
              //     ),
              //     decoration: BoxDecoration(
              //       gradient: const LinearGradient(
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //         colors: [
              //           Color.fromARGB(255, 227, 230, 233),
              //           Color.fromARGB(255, 196, 216, 233),
              //         ],
              //       ),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Html(
              //             data: detailedMenu.dish.utensils,
              //             style: {
              //               'body': Style(color: Color.fromARGB(255, 132, 130, 130)),
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
      
          ],
      
        ),
      ),
    );
  }
}