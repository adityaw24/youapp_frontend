import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:youapp_frontend/view/screen/auth_screen.dart';
import 'package:youapp_frontend/view/widget/image_section.dart';

const storage = FlutterSecureStorage();

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
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> dataLogin = jsonDecode(userData);

    return Scaffold(
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
          '@${widget.userData['username'] as String}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: ImageSection(
              userData: widget.userData,
            ),
          ),
        ],
      ),
    );
  }
}
