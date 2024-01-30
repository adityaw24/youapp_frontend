import 'package:flutter/material.dart';
import 'package:youapp_frontend/view/widget/add_interest.dart';

class InterestSection extends StatefulWidget {
  const InterestSection({
    super.key,
    required this.userData,
    required this.getProfile,
  });

  final List userData;
  final void Function() getProfile;

  @override
  State<InterestSection> createState() => _InterestSectionState();
}

class _InterestSectionState extends State<InterestSection> {
  // bool _isEditing = false;

  void _handleSubmit() {
    // setState(() {
    //   _isEditing = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Color colorBgChip = Color.fromRGBO(255, 255, 255, 0.2);

    Widget content = const Text(
      'Add in your interest to find a better match',
      style: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.52),
      ),
    );

    if (widget.userData.isNotEmpty) {
      content = Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 15,
        runSpacing: 10,
        children: [
          for (dynamic data in widget.userData.reversed)
            Chip(
              label: Text(
                data.toString().trim(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              backgroundColor: Colors.black87,
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
      // height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Interest',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddInterest(
                        userData:
                            widget.userData.isNotEmpty ? widget.userData : [],
                        getProfile: widget.getProfile,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
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
