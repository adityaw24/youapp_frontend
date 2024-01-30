import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youapp_frontend/service/utils.dart';

class FormDatePickerHorizontal extends StatefulWidget {
  const FormDatePickerHorizontal({
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

  @override
  State<FormDatePickerHorizontal> createState() =>
      _ForDatePickerHorizontalState();
}

class _ForDatePickerHorizontalState extends State<FormDatePickerHorizontal> {
  String? _value;
  // DateTime? _dateTime;
  TextEditingController _controller = TextEditingController();
  // late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.initValue != null ||
        widget.initValue.toString().trim().toLowerCase() != 'null' ||
        widget.initValue.toString().trim().toLowerCase() != 'error' ||
        widget.initValue.toString().trim().toLowerCase() != '') {
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

  DateTime? _formatDate(String date, String format) {
    DateTime? _result;
    try {
      final _newDate = DateFormat(format).parse(date);
      setState(() {
        _result = _newDate;
      });
    } catch (err) {
      // print('[Error format date] => $err');
      Utils.logError('format date picker', err);
      // _snackbarNotification('Invalid date type!');
    }
    return _result;
  }

  void _snackbarNotification(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _onSelectDate(DateTime date) {
    final dateTimeString = DateFormat('y-MM-dd').format(date);
    setState(() {
      _value = dateTimeString;
      _controller.text = dateTimeString;
    });
    widget.onChange(dateTimeString);
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
                  CupertinoDatePicker(
                    initialDateTime: widget.initValue != null
                        ? _formatDate(widget.initValue.toString(), 'y-MM-dd')
                        : null,
                    // use24hFormat: true,
                    // maximumYear: DateTime.now().year,
                    maximumDate: DateTime.now().add(const Duration(minutes: 1)),
                    mode: CupertinoDatePickerMode.date,
                    // This is called when the user changes the dateTime.
                    onDateTimeChanged: (newDateTime) {
                      _onSelectDate(newDateTime);
                    },
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
