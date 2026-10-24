import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    )
  );
}

/// Exception('메시지')의 'Exception: ' 접두어를 떼고 메시지만 돌려줌
String errorText(Object error) =>
    error.toString().replaceFirst('Exception: ', '');