// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String hintText;
  final double height;
  final RegExp validationRegEx;
  final AutovalidateMode autovalidateMode;
  final bool isSuffixIcon;
  final bool obsecureText;
  final void Function(String?) onSave;
  const CustomFormField({
    Key? key,
    required this.hintText,
    required this.height,
    required this.validationRegEx,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.isSuffixIcon = false,
    this.obsecureText = false,
    required this.onSave,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        autovalidateMode: widget.autovalidateMode,
        obscureText: (widget.obsecureText && isObsecure),
        onSaved: widget.onSave,
        validator: (value) {
          if (value != null && widget.validationRegEx.hasMatch(value)) {
            return null;
          }
          return 'Enter a valid ${widget.hintText.toLowerCase()}';
        },
        decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
            suffixIcon: widget.isSuffixIcon
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: isObsecure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  )
                : null),
      ),
    );
  }
}
