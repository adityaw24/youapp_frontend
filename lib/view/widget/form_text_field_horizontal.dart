import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextFieldHorizontal extends StatefulWidget {
  const FormTextFieldHorizontal({
    super.key,
    required this.label,
    this.onChange,
    this.placeholder,
    this.width = 0.5,
    this.isNumber = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.colorLabel = Colors.white,
    this.placeholderColor = Colors.white,
    this.textAlign = TextAlign.start,
    this.textFieldColor,
    this.borderColor = Colors.white,
    this.textColor,
    this.initValue,
    this.readOnly = false,
  });

  final String label;
  final String? placeholder;
  final double width;
  final void Function(dynamic value)? onChange;
  final bool isNumber;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final Color colorLabel;
  final Color placeholderColor;
  final TextAlign textAlign;
  final Color? textFieldColor;
  final Color borderColor;
  final Color? textColor;
  final dynamic initValue;
  final bool readOnly;

  @override
  State<FormTextFieldHorizontal> createState() =>
      _FormTextFieldHorizontalState();
}

class _FormTextFieldHorizontalState extends State<FormTextFieldHorizontal> {
  TextEditingController _controller = TextEditingController();
  // late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.initValue != null ||
        widget.initValue.toString().trim().toLowerCase() != 'null' ||
        widget.initValue.toString().trim().toLowerCase() != 'error' ||
        widget.initValue.toString().trim().toLowerCase() != '') {
      _controller = TextEditingController(text: widget.initValue.toString());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * widget.width;
    // var _controller = TextEditingController(text: widget.initValue);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: widget.colorLabel,
                ),
          ),
          Container(
            width: width,
            child: CupertinoTextField(
              placeholder: widget.placeholder,
              controller: _controller,
              // initialValue: widget.initValue ? widget.initValue.toString() : null,
              keyboardType:
                  widget.isNumber ? TextInputType.number : TextInputType.text,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                color: widget.textFieldColor,
                border: Border.all(
                  color: widget.borderColor,
                ),
              ),
              placeholderStyle: TextStyle(
                color: widget.placeholderColor,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              enableSuggestions: true,
              style: TextStyle(
                color: widget.textColor,
              ),
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              prefix: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                ),
                child: widget.prefix,
              ),
              suffix: Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                ),
                child: widget.suffix,
              ),
              textAlign: widget.textAlign,
              onChanged: (value) {
                widget.onChange!(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
