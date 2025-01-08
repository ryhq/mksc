import 'package:flutter/material.dart';
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/views/authentication/authentication_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<bool> validToken({required String title}) async{
  TokenStorage tokenStorage = TokenStorage();
  AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);
  if (authToken.token.isEmpty || authToken.expireAt.isBefore(DateTime.now())) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AuthenticationPage(title: title)),
      (route) => false,
    );
    return false;
  }
  return true;
}
