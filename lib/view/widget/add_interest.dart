import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';
import 'package:youapp_frontend/service/utils.dart';
import 'package:hexcolor/hexcolor.dart';

const httpRequest = HttpRequest();

class AddInterest extends StatefulWidget {
  const AddInterest({
    super.key,
    required this.userData,
    required this.getProfile,
  });

  final List userData;
  final void Function() getProfile;

  @override
  State<AddInterest> createState() => _AddInterestState();
}

class _AddInterestState extends State<AddInterest> {
  // List listInterest = [];
  late List listInterest;
  TextEditingController _controller = TextEditingController();

  void _addInterest(String value) {
    final index = listInterest.indexWhere(
      (data) =>
          data.toString().trim().toLowerCase() == value.toLowerCase().trim(),
    );
    setState(() {
      if (index != -1) {
        listInterest.removeAt(index);
      }
      listInterest.add(value);
    });

    _controller.clear();
    // FocusScope.of(context).unfocus;
    // print('[add interest] => ${jsonEncode(listInterest)}');
  }

  void _handleSubmit() async {
    final body = jsonEncode({
      'interests': listInterest,
    });

    try {
      await httpRequest.updateProfile(body);
    } catch (err) {
      // print('[Error updating profile] => $err');
      Utils.logError('updating about profile', err);
      _notification('Failed updating profile!');
    }

    widget.getProfile();
    _goBack();
  }

  void _notification(String message) {
    Utils.snackbarNotification(context, message);
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      listInterest = widget.userData;
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
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            HexColor('#1F4247'),
            HexColor('#0D1D23'),
            HexColor('#09141A'),
          ],
          center: Alignment.topRight,
          radius: 2.3,
        ),
      ),
      child: Scaffold(
        // backgroundColor: Color.fromRGBO(9, 20, 26, 1),
        backgroundColor: Colors.transparent,
        appBar: CupertinoNavigationBar(
          // padding: const EdgeInsetsDirectional.only(
          //   top: 8,
          // ),
          backgroundColor: Colors.transparent,
          leading: TextButton.icon(
            onPressed: _goBack,
            icon: const Icon(Icons.keyboard_arrow_left),
            label: const Text('Back'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
          trailing: TextButton(
            onPressed: _handleSubmit,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.blueAccent.shade100,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: SafeArea(
            minimum: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tell everyone about yourself',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.amber,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'What interest you?',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        // fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, 0.1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CupertinoTextField.borderless(
                        controller: _controller,
                        placeholder: 'Input your interest',
                        placeholderStyle: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onSubmitted: (value) {
                          _addInterest(value);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        spacing: 15,
                        runSpacing: 10,
                        children: [
                          for (dynamic data in listInterest.reversed)
                            Chip(
                              label: Text(
                                data.toString().trim(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              backgroundColor: Colors.black54,
                              deleteIcon: const Icon(Icons.close),
                              deleteIconColor: Colors.white,
                              onDeleted: () {
                                setState(() {
                                  listInterest.remove(data);
                                });
                                // print(
                                //     '[delete interest] => ${jsonEncode(listInterest)}');
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
