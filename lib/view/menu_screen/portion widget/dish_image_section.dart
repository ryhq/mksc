import 'package:flutter/material.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class DishImageSection extends StatefulWidget {
  const DishImageSection({super.key});

  @override
  State<DishImageSection> createState() => _DishImageSectionState();
}

class _DishImageSectionState extends State<DishImageSection> {
  @override
  Widget build(BuildContext context) {
    DetailedMenu detailedMenu = Provider.of<MenuProvider>(context, listen: true).detailedMenu;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Dish Image",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        
        GestureDetector(
          onTap: () {
            debugPrint("\n\n\nTapped as picture...👍👍👍\n\n\n");
            showDialog(
              context: context, 
              builder: (context) => Dialog(
                elevation: 3.0,
                backgroundColor: Colors.transparent,
                insetAnimationCurve: Curves.slowMiddle,
                insetAnimationDuration: const Duration(milliseconds: 700),
                insetPadding: const EdgeInsets.all(21),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21.0),
                  child: PhotoView(
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    imageProvider: NetworkImage(detailedMenu.image,),
                    heroAttributes: PhotoViewHeroAttributes(tag: detailedMenu.image),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9)
                    ),
                  ),
                ),
              ),
            );
          },
          child: Hero(
            tag: detailedMenu.image,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Card(
                elevation: 12.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(21.0)),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 300,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(21.0)),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(21.0)),
                    child: Image.network(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      detailedMenu.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          // Image has loaded
                          return child;
                        } else {
                          // Image is still loading
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 350,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 350,
                            child: Icon(
                              Icons.error,
                              size: 50,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}