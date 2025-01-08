import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/providers/menu_provider.dart';
import 'package:mksc/utilities/color_utility.dart';
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
                
            const SizedBox(height: 12.0,),

            if(detailedMenu.dish.recipe.toString().isNotEmpty)...[
            
              Text(
                "Recipe Details",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorUtility.calculateSecondaryColorWithAlpha(primaryColor: Theme.of(context).colorScheme.primary, alpha: 90),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: detailedMenu.dish.recipe,
                    style: {
                      'body': Style(color: const Color.fromARGB(255, 132, 130, 130),),
                    },
                  ),
                ),
              ),
            ],
                
            const SizedBox(height: 12.0,),

            if(detailedMenu.dish.tableware.toString().isNotEmpty)...[
            
              Text(
                "Tableware",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              Container(
                decoration: BoxDecoration(
                  color: ColorUtility.calculateSecondaryColorWithAlpha(primaryColor: Theme.of(context).colorScheme.primary, alpha: 90),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: detailedMenu.dish.tableware,
                    style: {
                      'body': Style(color: const Color.fromARGB(255, 132, 130, 130)),
                    },
                  ),
                ),
              ),
            ],
                
            const SizedBox(height: 12.0,),

            if(detailedMenu.dish.tableware.toString().isNotEmpty)...[
            
              Text(
                "Utensils",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorUtility.calculateSecondaryColorWithAlpha(primaryColor: Theme.of(context).colorScheme.primary, alpha: 90),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: detailedMenu.dish.utensils,
                    style: {
                      'body': Style(color: const Color.fromARGB(255, 132, 130, 130)),
                    },
                  ),
                ),
              ),
            ],
      
          ],
      
        ),
      ),
    );
  }
}