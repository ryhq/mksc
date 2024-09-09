
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/inputData/input_data_page.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';

class MajorCategoryCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  const MajorCategoryCard({
    super.key, required this.title, required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showAppModalBottomSheet(
          context, 
          [
            AppTextFormField(
              hintText: "Add $title data", 
              iconData: Icons.add, 
              obscureText: false, 
              textInputType: TextInputType.text
            ),
            const SizedBox(height: 8.0,),
            const AppTextFormField(
              hintText: "Click to Consult", 
              iconData: Icons.visibility, 
              obscureText: false, 
              textInputType: TextInputType.text
            ),
          ],
        );
      },
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InputDataPage(categoryTitle: title),)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 14.0),
        child: Card(
          elevation: 3,
          shape: const  RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(21))
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(21.0)),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1.5
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            // width: ((MediaQuery.of(context).size.width) / 100) * 40,
            // height: ((MediaQuery.of(context).size.height) / 100) * 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:  7, vertical:  14,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    iconData,
                    size: Provider.of<ThemeProvider>(context).fontSize + 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  ListTile(
                    title: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    trailing: Icon(
                      CupertinoIcons.forward,
                      size: Provider.of<ThemeProvider>(context).fontSize + 7,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void showAppModalBottomSheet(BuildContext context, List<Widget> widget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.25,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 21.0, horizontal: 14.0),
              child: ListView(
                controller: scrollController,
                children: widget,
              ),
            );
          },
        );
      },
    );
  }
}

