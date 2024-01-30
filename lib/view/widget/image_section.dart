import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.userData,
  });

  final dynamic userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: userData['image'] != null
          ? BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(userData['image']),
              ),
            )
          : null,
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
      // alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '@${userData['username'] as String}',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          if (userData['gender'] != null)
            Text(
              userData['gender'] as String,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
        ],
      ),
    );
  }
}
