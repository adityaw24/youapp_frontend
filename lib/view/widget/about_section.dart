import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';
import 'package:youapp_frontend/service/utils.dart';
import 'package:youapp_frontend/view/widget/form_datepicker_horizontal.dart';
import 'package:youapp_frontend/view/widget/form_select_horizontal.dart';
import 'package:youapp_frontend/view/widget/form_text_field_horizontal.dart';
import 'package:youapp_frontend/view/widget/user_image_picker.dart';
import 'package:youapp_frontend/view/widget/view_item_profile.dart';

const httpRequest = HttpRequest();

class AboutSection extends StatefulWidget {
  const AboutSection({
    super.key,
    required this.userData,
    required this.getProfile,
  });

  final dynamic userData;
  final void Function() getProfile;

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isEditing = false;
  Map<String, dynamic> _bodyJson = {};

  final listGender = <String>['Male', 'Female'];

  void _addToMapJson({
    required String key,
    dynamic value,
  }) {
    _bodyJson.update(key, (v) => value, ifAbsent: () => value);
  }

  void _handleSubmit() async {
    // widget.onSubmit;
    final body = jsonEncode(_bodyJson);

    try {
      await httpRequest.updateProfile(body);
    } catch (err) {
      // print('[Error updating profile] => $err');
      Utils.logError('updating about profile', err);
      _notification('Failed updating profile!');
    }

    // await httpRequest.getProfile();
    widget.getProfile();
    setState(() {
      _isEditing = false;
    });
  }

  void _notification(String message) {
    Utils.snackbarNotification(context, message);
  }

  @override
  Widget build(BuildContext context) {
    Color colorLabel = Color.fromRGBO(255, 255, 255, 0.3);

    Widget content = const Text(
      'Add in your your to help others know you better',
      style: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.52),
      ),
    );

    if (_isEditing) {
      content = Column(
        children: [
          UserImagePicker(
            onSelectedImage: (selectedImage) {
              _addToMapJson(
                key: 'image',
                value: selectedImage.path,
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          FormTextFieldHorizontal(
            label: 'Display Name:',
            textAlign: TextAlign.end,
            textColor: Colors.white,
            initValue: widget.userData['name'],
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: Color.fromRGBO(255, 255, 255, 0.22),
            placeholder: 'Enter name',
            placeholderColor: colorLabel,
            onChange: (value) {
              final trimValue = value.toString().trim();
              _addToMapJson(
                key: 'name',
                value: trimValue,
              );
            },
            width: 0.5,
          ),
          FormSelectHorizontal(
            label: 'Gender:',
            initValue: widget.userData['gender'],
            optionSelect: listGender,
            textAlign: TextAlign.end,
            textColor: Colors.white,
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: Color.fromRGBO(255, 255, 255, 0.22),
            placeholder: 'Select gender',
            placeholderColor: colorLabel,
            onChange: (value) {
              final trimValue = value.toString().trim();
              _addToMapJson(
                key: 'gender',
                value: trimValue,
              );
            },
            width: 0.5,
          ),
          FormDatePickerHorizontal(
            label: 'Birthday:',
            initValue: widget.userData['birthday'],
            textAlign: TextAlign.end,
            textColor: Colors.white,
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: Color.fromRGBO(255, 255, 255, 0.22),
            placeholder: 'Select date',
            placeholderColor: colorLabel,
            onChange: (value) {
              final trimValue = value.toString().trim();
              _addToMapJson(
                key: 'birthday',
                value: trimValue,
              );
            },
            width: 0.5,
          ),
          FormTextFieldHorizontal(
            label: 'Horoscope:',
            initValue: widget.userData['horoscope'],
            textAlign: TextAlign.end,
            textColor: Colors.white,
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: Color.fromRGBO(255, 255, 255, 0.22),
            placeholder: '--',
            placeholderColor: colorLabel,
            // enabled: false,
            readOnly: true,
            width: 0.5,
          ),
          FormTextFieldHorizontal(
            label: 'Zodiac:',
            initValue: widget.userData['zodiac'],
            textAlign: TextAlign.end,
            textColor: Colors.white,
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: Color.fromRGBO(255, 255, 255, 0.22),
            placeholder: '--',
            placeholderColor: colorLabel,
            // enabled: false,
            readOnly: true,
            width: 0.5,
          ),
          FormTextFieldHorizontal(
            label: 'Height:',
            initValue: widget.userData['height'],
            textAlign: TextAlign.end,
            textColor: Colors.white,
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: colorLabel,
            placeholder: 'Add height',
            placeholderColor: colorLabel,
            onChange: (value) {
              final trimValue = value.toString().trim();
              _addToMapJson(
                key: 'height',
                value: int.tryParse(trimValue),
              );
            },
            suffix: Text(
              'cm',
              style: TextStyle(
                color: colorLabel,
              ),
            ),
            width: 0.5,
            isNumber: true,
          ),
          FormTextFieldHorizontal(
            label: 'Weight:',
            initValue: widget.userData['weight'],
            textAlign: TextAlign.end,
            textColor: Colors.white,
            colorLabel: colorLabel,
            textFieldColor: Color.fromRGBO(255, 255, 255, 0.1),
            borderColor: colorLabel,
            placeholder: 'Add weight',
            placeholderColor: colorLabel,
            onChange: (value) {
              final trimValue = value.toString().trim();
              _addToMapJson(
                key: 'weight',
                value: int.tryParse(trimValue),
              );
            },
            suffix: Text(
              'kg',
              style: TextStyle(
                color: colorLabel,
              ),
            ),
            width: 0.5,
            isNumber: true,
          ),
        ],
      );
    }

    if (!_isEditing &&
        (widget.userData['birthday'] != null ||
            widget.userData['horoscope'] != null ||
            widget.userData['height'] != null ||
            widget.userData['height'] != 0 ||
            widget.userData['weight'] != null ||
            widget.userData['weight'] != 0)) {
      content = Column(
        children: [
          ViewItemProfile(
            label: 'Birthday',
            value: widget.userData['birthday'],
            colorLabel: colorLabel,
            colorValue: Colors.white,
          ),
          ViewItemProfile(
            label: 'Horoscope',
            value: widget.userData['horoscope'],
            colorLabel: colorLabel,
            colorValue: Colors.white,
          ),
          ViewItemProfile(
            label: 'Zodiac',
            value: widget.userData['zodiac'],
            colorLabel: colorLabel,
            colorValue: Colors.white,
          ),
          ViewItemProfile(
            label: 'Height',
            value: '${widget.userData['height']} cm',
            colorLabel: colorLabel,
            colorValue: Colors.white,
          ),
          ViewItemProfile(
            label: 'Weight',
            value: '${widget.userData['weight']} kg',
            colorLabel: colorLabel,
            colorValue: Colors.white,
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color.fromRGBO(14, 25, 31, 1),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              if (!_isEditing)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              if (_isEditing)
                TextButton(
                  onPressed: _handleSubmit,
                  child: Text(
                    'Save & Update',
                    style: TextStyle(
                      color: Colors.amber.shade200,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: content,
          ),
        ],
      ),
    );
  }
}
