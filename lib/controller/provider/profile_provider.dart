import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileNotifier extends StateNotifier<Map<String, dynamic>> {
  ProfileNotifier()
      : super({
          'token': null,
          'dataLogin': null,
          'dataProfile': null,
        });

  void saveDataLogin(
    String token,
  ) {
    final userData = JwtDecoder.decode(token);
    state = {
      ...state,
      'dataLogin': jsonEncode(userData),
      'token': token,
    };
  }

  void saveDataProfile(
    Map<String, dynamic> profile,
  ) {
    state = {
      ...state,
      'dataProfile': jsonEncode(profile),
    };
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, Map<String, dynamic>>(
  (ref) => ProfileNotifier(),
);
