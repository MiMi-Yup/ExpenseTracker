import 'package:flutter/material.dart';

StatefulBuilder editText(
    {required void Function(String)? onChanged,
    String? fillText,
    String? labelText,
    String? hintText,
    bool isPassword = false}) {
  TextEditingController _controller = TextEditingController(text: fillText);
  bool _obscureText = isPassword;
  return StatefulBuilder(
      builder: (context, setState) => Container(
          padding: EdgeInsets.only(top: 8.0),
          child: TextField(
              controller: _controller,
              obscureText: _obscureText,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: isPassword ? TextInputType.visiblePassword : null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: labelText,
                  hintText: hintText,
                  suffixIcon: isPassword
                      ? IconButton(
                          onPressed: () =>
                              setState((() => _obscureText = !_obscureText)),
                          icon: _obscureText
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off))
                      : null),
              autofocus: false,
              onChanged: onChanged)));
}
