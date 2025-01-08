import 'package:flutter/material.dart';
import 'package:mksc/navigator_key.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/views/home/mksc_home.dart';
import 'package:provider/provider.dart';

class LogOutActionButton extends StatelessWidget {
  const LogOutActionButton({
    super.key,
    required this.categoryTitle,
  });

  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout $categoryTitle',
      onPressed: () async{
    
        TokenStorage tokenStorage = TokenStorage();
    
        await tokenStorage.deleteToken(tokenKey: categoryTitle);
    
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MKSCHome(),), 
          (Route<dynamic> route) => false
        );
      },
      icon: Icon(
        Icons.logout,
        color:Colors.white,
        size: Provider.of<ThemeProvider>(context).fontSize + 7,
      )
    );
  }
}
