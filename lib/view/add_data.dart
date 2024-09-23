import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class AddData extends StatefulWidget {
  final String title;

  const AddData({super.key, required this.title});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  CupertinoIcons.back,
                  color: Theme.of(context).colorScheme.primary,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
                ),
              ),
            );
          },
        ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
    );
  }
}