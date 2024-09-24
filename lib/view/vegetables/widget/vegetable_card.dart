
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class VegetableCard extends StatefulWidget {
  const VegetableCard({
    super.key,
    required this.vegetableData,
  });

  final Vegetable vegetableData;

  @override
  State<VegetableCard> createState() => _VegetableCardState();
}

class _VegetableCardState extends State<VegetableCard> {  
  
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add listener to the focus node to rebuild when focus changes
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the focus node to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _focusNode.hasFocus;
    return Column(
      children: [
        Focus(
          focusNode: _focusNode,
          child: GestureDetector(
            onTap: () {
              if (isFocused) {
                _focusNode.unfocus();
              }else{
                _focusNode.requestFocus(); 
              }
            },
            child: Stack(
              children: [
                Card(
                  elevation: 3,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(21.0))),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 150.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21.0),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          Colors.grey[50]!,
                          Colors.blue[100]!,
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                
                        // image
                        widget.vegetableData.image.isNotEmpty ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            widget.vegetableData.image, 
                            width: 140,
                            height: 140,
                            errorBuilder: (context, error, stackTrace) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                        ) 
                        : 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                
                        // Details
                
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.vegetableData.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 10,),
                            
                              Text(
                                "Quantity : 32",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // actions
                if(isFocused)...[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 150.0),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              tooltip: 'Add ${widget.vegetableData.name} data',
                              onPressed: () {
                                
                              }, 
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: Provider.of<ThemeProvider>(context).fontSize + 21,
                              )
                            ),
                            IconButton(
                              tooltip: 'Edit ${widget.vegetableData.name} data',
                              onPressed: () {
                                
                              }, 
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: Provider.of<ThemeProvider>(context).fontSize + 21,
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
    
        // const SizedBox(height: 21,)
      ],
    );
  }
}