import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAlert {
  static void showAlert(BuildContext context, String title, String alertMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium
        ),
        content: Text(
          alertMessage,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.red
          )
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.labelLarge
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  static void showCopiedText(
      BuildContext context, String title, String copiedMessage) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from closing by tapping outside
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium
        ),
        content: Text(
          copiedMessage,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            letterSpacing: 3.0
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Copy',
              style: Theme.of(context).textTheme.labelLarge
            ),
            onPressed: () {
              copyToClipboard(copiedMessage, context);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  static void copyToClipboard(String text, BuildContext context) {
    final data = ClipboardData(text: text);
    Clipboard.setData(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  static void showPopUps(BuildContext context, List<Widget> widget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.25,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 21.0),
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

  static void showAppModalBottomSheet(
    BuildContext context,
    bool isScrollControlled,
    Widget widget,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                double maxHeight =
                    constraints.maxHeight * 0.5; // Half of the screen height
                return Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight,
                      minHeight: 0,
                    ),
                    child: IntrinsicHeight(
                      child: widget,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
