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
            const SizedBox(
              height: 5,
            ),
          if (userData['gender'] != null)
            Text(
              userData['gender'] as String,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          if (userData['horoscope'] != null || userData['zodiac'] != null)
            const SizedBox(
              height: 10,
            ),
          if (userData['horoscope'] != null || userData['zodiac'] != null)
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              spacing: 15,
              runSpacing: 10,
              children: [
                if (userData['horoscope'] != null)
                  Chip(
                    label: Text(
                      userData['horoscope'].toString().trim(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // avatar: Icon(Icons),
                    backgroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.transparent),
                  ),
                if (userData['horoscope'] != null)
                  Chip(
                    label: Text(
                      userData['zodiac'].toString().trim(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    // avatar: Icon(Icons),
                    backgroundColor: Colors.black87,
                    side: const BorderSide(color: Colors.transparent),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
