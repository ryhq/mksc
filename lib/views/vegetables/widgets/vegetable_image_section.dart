import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:photo_view/photo_view.dart';

class VegetableImageSection extends StatefulWidget {
  const VegetableImageSection({super.key, required this.vegetable});
  final Vegetable vegetable;

  @override
  State<VegetableImageSection> createState() => _VegetableImageSectionState();
}

class _VegetableImageSectionState extends State<VegetableImageSection> {
  @override
  Widget build(BuildContext context) {
    return 
    widget.vegetable.image.isNotEmpty ?

    GestureDetector(
      onTap: () {
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
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                child: PhotoView(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  imageProvider: NetworkImage(widget.vegetable.image,),
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.vegetable.image + widget.vegetable.name),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9)
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: widget.vegetable.image + widget.vegetable.name,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            widget.vegetable.image, 
            width: 140,
            height: 140,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                // Image has loaded
                return child;
              } else {
                // Image is still loading
                return SizedBox(
                  width: 140,
                  height: 140,
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
                  width: 140,
                  height: 140,
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
    )
    :
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 140,
        height: 140,
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}