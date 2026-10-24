import 'package:flutter/services.dart';

/// 이메일에 쓸 수 있는 문자만 입력되게 함.
/// 한글, 공백은 직접 입력이든 붙여넣기든 걸러진다.
final List<TextInputFormatter> emailInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@._%+\-]')),
];

/// 이메일 형식 검사. 올바르면 true.
bool isValidEmail(String value) {
  return RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$',
  ).hasMatch(value.trim());
}