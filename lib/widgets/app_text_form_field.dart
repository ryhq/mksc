import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatefulWidget {
  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final TextInputType textInputType;
  final Function(String)? onChanged;
  final GestureTapCallback? onTap;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final TextStyle? style;
  const AppTextFormField({
    super.key,
    required this.hintText,
    required this.iconData,
    required this.obscureText,
    required this.textInputType,
    this.textEditingController,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.validator,
    this.onTap,
    this.inputFormatters,
    this.hintStyle,
    this.style
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
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      controller: widget.textEditingController,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      keyboardType: widget.textInputType,
      textInputAction: TextInputAction.done,
      obscureText: showPassword ? false : widget.obscureText,
      inputFormatters: widget.inputFormatters,
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
        hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(vertical: 21),
        // contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
      style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}
