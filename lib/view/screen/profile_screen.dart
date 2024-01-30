import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youapp_frontend/controller/network/http_request.dart';
import 'package:youapp_frontend/view/screen/auth_screen.dart';
import 'package:youapp_frontend/view/widget/image_section.dart';
import 'package:youapp_frontend/view/widget/about_section.dart';
import 'package:youapp_frontend/service/utils.dart';

const storage = FlutterSecureStorage();
const httpRequest = HttpRequest();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userData,
  });

  final dynamic userData;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  dynamic dataProfile;
  late Future<Map<String, dynamic>> _getProfile;
  Map<String, dynamic> _bodyJson = {};

  void _logout(BuildContext context) {
    storage.deleteAll();
    Navigator.of(context).pop();
  }

  void _checkToken() {
    storage.read(key: 'access_token').then((value) {
      if (value == null || value.trim() == '') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );

        _snackbarNotification('Session expired, Please login again');
      }
    });
  }

  void _addToMapJson(String key, dynamic value) {
    _bodyJson.update(key, (v) => value, ifAbsent: () => value);
  }

  void _snackbarNotification(String message) {
    Utils.snackbarNotification(context, message);
  }

  // Future<Map<String, dynamic>> _getProfile = httpRequest.getProfile();

  void _refetchProfile() {
    setState(() {
      _getProfile = httpRequest.getProfile();
    });
  }

  // void _onUpdateProfile() async {
  //   final body = jsonEncode(_bodyJson);

  //   try {
  //     await httpRequest.updateProfile(body);
  //   } catch (err) {
  //     print('[Error updating profile] => $err');
  //     _snackbarNotification('Failed updating profile!');
  //   }

  //   await httpRequest.getProfile();
  // }

  @override
  void initState() {
    super.initState();
    _checkToken();
    _getProfile = httpRequest.getProfile();
    httpRequest.getProfile().then((value) {
      setState(() {
        _bodyJson = value['data'];
      });
      // print('body json profile => ${jsonEncode(_bodyJson)}');
    });

    // _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;

    return FutureBuilder<Map<String, dynamic>>(
      future: _getProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          content = Scaffold(
            backgroundColor: Color.fromRGBO(9, 20, 26, 1),
            appBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              leading: TextButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          content = Scaffold(
            backgroundColor: Color.fromRGBO(9, 20, 26, 1),
            appBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              leading: TextButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          content = Scaffold(
            backgroundColor: Color.fromRGBO(9, 20, 26, 1),
            appBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              leading: TextButton.icon(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.keyboard_arrow_left),
                label: const Text('Back'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
              middle: Text(
                '@${snapshot.data!['data']['username'] as String}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.all(12),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: ImageSection(
                      userData: snapshot.data!['data'],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AboutSection(
                      userData: snapshot.data!['data'],
                      getProfile: () {
                        _refetchProfile();
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 24,
                      ),
                      child: Center(
                        child: Text(
                          'Data: ${snapshot.data!['data']}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return content!;
      },
    );
  }
}
