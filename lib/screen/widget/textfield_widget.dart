import 'package:flutter/material.dart';
import 'package:talk/utils/app_colors.dart';
import 'package:talk/utils/app_decoration.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.obscureText,
    this.onSuffixIxonTap,
    this.contentPadding,
    this.minLines,
    this.maxLines,
    this.errorText,
    this.textInputAction,
    this.enabled,
    this.hint,
    this.suffix,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final VoidCallback? onSuffixIxonTap;
  final int? minLines;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final bool? enabled;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      cursorColor: AppColors.kPrimaryColor,
      onEditingComplete: onEditingComplete,
      validator: validator,
      obscureText: obscureText != null ? obscureText! : false,
      // scrollPadding: Ed,
      style: Theme.of(context)
          .inputDecorationTheme
          .hintStyle
          ?.copyWith(color: AppColors.kBlackColor),
      decoration: InputDecoration(
        suffixIcon: suffix,

        labelText: label,
        hintText: hint,
        errorMaxLines: 2,
        errorText: errorText,
        prefixIcon: prefixIcon == null
            ? null
            : Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.only(left: 6),
                child: Icon(
                  prefixIcon,
                  size: 20,
                  color: AppColors.kSecondaryColor,
                ),
              ),
        // suffixIcon: suffixIcon == null
        //     ? null
        //     : GestureDetector(
        //         onTap: onSuffixIxonTap,
        //         child: Container(
        //           color: Colors.transparent,
        //           child: Icon(
        //             suffixIcon,
        //             size: 20,
        //             color: Theme.of(context).textTheme.bodySmall?.color,
        //           ),
        //         ),
        //       ),
        contentPadding: contentPadding ?? const EdgeInsets.only(left: 50),
        border: AppDecoration.kInputBorder,
        enabledBorder: AppDecoration.kInputBorder,
        focusedBorder: AppDecoration.kInputBorder,
        errorBorder: AppDecoration.kErrorInputBorder,
        disabledBorder: AppDecoration.kInputBorder,
        focusedErrorBorder: AppDecoration.kInputBorder,
      ),
    );
  }
}
