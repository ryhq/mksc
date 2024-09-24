import 'package:flutter/material.dart';
import 'package:mksc/view/authentication_page.dart';

class NonMenuContentBottomSheet extends StatelessWidget {
  final String title;
  const NonMenuContentBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            if (title == "Laundry") {

            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthenticationPage(title: title),
                )
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: ListTile(
                  title: Text(
                    "Add $title data",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  contentPadding: const EdgeInsets.all(0.0),
                )
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            if (title == "Laundry") {
            } else {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AuthenticationPage(title: title),
              //   )
              // );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: ListTile(
                  title: Text(
                    "Click to Consult $title",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.visibility,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  contentPadding: const EdgeInsets.all(0.0),
                )
              ),
            ),
          ),
        ),
      ],
    );
  }
}
