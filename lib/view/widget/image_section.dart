import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({
    super.key,
    required this.userData,
  });

  final dynamic userData;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        color: Color.fromRGBO(22, 35, 41, 1),
      ),
      padding: const EdgeInsets.all(16),
      height: 190,
      width: double.infinity,
      alignment: Alignment.bottomLeft,
      child: Text(
        '@${widget.userData['username'] as String}',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
            ),
      ),
    );

    if (widget.userData['image'] != null) {
      content = Container(
        foregroundDecoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.userData['image']),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: Color.fromRGBO(22, 35, 41, 1),
        ),
        padding: const EdgeInsets.all(16),
        height: 190,
        width: double.infinity,
        alignment: Alignment.bottomLeft,
        child: Text(
          '@${widget.userData['username'] as String}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      );
    }

    return content;
  }
}
