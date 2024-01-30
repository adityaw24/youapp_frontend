import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSelectHorizontal extends StatefulWidget {
  const FormSelectHorizontal({
    super.key,
    required this.label,
    required this.onChange,
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
    this.initValue,
    this.textColor,
    this.readOnly = false,
    required this.optionSelect,
    this.heightOption = 32,
  });

  final String label;
  final String? placeholder;
  final double width;
  final void Function(dynamic value) onChange;
  final bool isNumber;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final Color colorLabel;
  final Color placeholderColor;
  final TextAlign textAlign;
  final Color? textFieldColor;
  final Color borderColor;
  final dynamic initValue;
  final Color? textColor;
  final bool readOnly;
  final List<String> optionSelect;
  final double heightOption;

  @override
  State<FormSelectHorizontal> createState() => _ForDatePickerHorizontalState();
}

class _ForDatePickerHorizontalState extends State<FormSelectHorizontal> {
  String? _value;
  TextEditingController _controller = TextEditingController();
  // late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.initValue != null) {
      setState(() {
        _value = widget.initValue.toString();
      });
      _controller = TextEditingController(text: _value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snackbarNotification(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  int _findIndexItem() {
    final index = widget.optionSelect.indexWhere(
      (opt) =>
          opt.trim().toLowerCase() ==
          widget.initValue.toString().trim().toLowerCase(),
    );
    if (index == -1) {
      return 0;
    }
    return index;
  }

  void _onSelectedItem(int index) {
    final itemSelected = widget.optionSelect[index];
    setState(() {
      _controller.text = itemSelected;
    });
    widget.onChange(itemSelected);
    FocusScope.of(context).unfocus();
  }

  void _showDialog(Widget child) {
    FocusScope.of(context).requestFocus(FocusNode());
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * widget.width;

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
              readOnly: true,
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
              // onChanged: (value) {
              //   widget.onChange!(value);
              // },
              onTap: () {
                _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: widget.heightOption,
                    // This sets the initial item.
                    scrollController: FixedExtentScrollController(
                      initialItem: _findIndexItem(),
                    ),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (selectedItem) {
                      _onSelectedItem(selectedItem);
                      setState(() {
                        _controller.text = widget.optionSelect[selectedItem];
                      });
                    },
                    children: List<Widget>.generate(widget.optionSelect.length,
                        (index) {
                      return Center(
                        child: Text(widget.optionSelect[index]),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
