import 'package:flutter/material.dart';

enum ETypeEditText { email, password, normal }

class EditText extends StatefulWidget {
  void Function(String?)? onChanged;
  String? fillText;
  String? labelText;
  String? hintText;
  bool? autofocus;
  ETypeEditText type;
  String? errorText;
  late RegExp _regex;
  bool enableRegex;
  EditText(
      {Key? key,
      required this.onChanged,
      this.fillText,
      this.labelText,
      this.hintText,
      this.autofocus,
      this.errorText,
      this.enableRegex = false,
      this.type = ETypeEditText.normal})
      : super(key: key) {
    if (enableRegex) {
      switch (type) {
        case ETypeEditText.email:
          _regex = RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
          break;
        case ETypeEditText.password:
          _regex = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          break;
        default:
      }
    }
  }

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  late bool _obscureText;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == ETypeEditText.password;
    _controller = TextEditingController(text: widget.fillText);
    _controller.addListener(() {
      if (widget.enableRegex) {
        widget.errorText = null;

        if (_controller.text.isNotEmpty) {
          switch (widget.type) {
            case ETypeEditText.email:
              if (!widget._regex.hasMatch(_controller.text)) {
                widget.errorText = "Wrong email format";
              }
              break;
            case ETypeEditText.password:
              if (!widget._regex.hasMatch(_controller.text)) {
                widget.errorText =
                    "Weak password! Please try stronger passwrod";
              }
              break;
            case ETypeEditText.normal:
              break;
          }
          setState(() {});
        } else {
          setState(() => widget.errorText = "Cannot empty");
        }
        if (widget.onChanged != null) {
          widget.errorText == null
              ? widget.onChanged!(_controller.text)
              : widget.onChanged!(null);
        }
      } else if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8.0),
        child: TextField(
            controller: _controller,
            obscureText: _obscureText,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: widget.type == ETypeEditText.password
                ? TextInputType.visiblePassword
                : null,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: widget.labelText,
                hintText: widget.hintText,
                errorText: widget.errorText,
                suffixIcon: widget.type == ETypeEditText.password
                    ? IconButton(
                        onPressed: () =>
                            setState((() => _obscureText = !_obscureText)),
                        icon: _obscureText
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off))
                    : null),
            autofocus: widget.autofocus ?? false));
  }
}
