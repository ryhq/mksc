import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final bool readOnly;
  final TextInputType textInputType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;
  const AppTextFormField({
    super.key,
    required this.hintText,
    required this.iconData,
    required this.obscureText,
    required this.textInputType,
    this.textEditingController,
    this.readOnly = false,
    this.onChanged,
    this.validator,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool showPassword = false;
  bool isFocused = false;
  late FocusNode _focusNode;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      // minLines: 1,
      // maxLines: 3,
      controller: widget.textEditingController,
      onChanged: widget.onChanged,
      validator: widget.validator,
      readOnly: widget.readOnly,
      keyboardType: widget.textInputType,
      textInputAction: TextInputAction.done,
      obscureText: showPassword ? false : widget.obscureText,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.5, 
            color: Theme.of(context).colorScheme.onSurface
          ),
          borderRadius: BorderRadius.circular(21.0)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5, 
            color: Theme.of(context).colorScheme.primary
          ),
          borderRadius: BorderRadius.circular(21.0)
        ),
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        border: const OutlineInputBorder(),
        prefixIcon: Container(
          height: 50.0,
          width: 30.0,
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7.0),
              topLeft: Radius.circular(7.0)
            ),
          ),
          child: Icon(
            widget.iconData, 
            color: isFocused ? Theme.of(context).colorScheme.primary :Theme.of(context).colorScheme.onSurface
          ),
        ),
        suffixIcon: widget.obscureText ? 
        Container(
          height: 50.0,
          width: 30.0,
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(7.0),
              topLeft: Radius.circular(7.0)
            ),
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          icon: showPassword ? 
            Icon(
              Icons.visibility_off, 
              color: isFocused ? Theme.of(context).colorScheme.primary :Theme.of(context).colorScheme.onSurface,
            ) : 
            Icon(
              Icons.visibility, 
              color: isFocused ? Theme.of(context).colorScheme.primary :Theme.of(context).colorScheme.onSurface,
            ),
          color: Theme.of(context).colorScheme.primary),
        ) : null
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
