import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zalo_flutter/zalo_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _indexReset = -1;
  var _key = const ValueKey('');
  
  @override
  void initState() {
    super.initState();
    _initZaloFlutter();
  }

  Future<void> _initZaloFlutter() async {
    if (Platform.isAndroid) {
      final hashKey = await ZaloFlutter.getHashKeyAndroid();
      log('HashKey: $hashKey');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CommonButton(
                  text: 'clear log',
                  onPressed: () async {
                    _indexReset++;
                    _key = ValueKey(_indexReset.toString());
                    setState(() {});
                    return null;
                  },
                ),
                CommonButton(
                  text: 'logout',
                  onPressed: () async {
                    await ZaloFlutter.logout();
                    _indexReset++;
                    _key = ValueKey(_indexReset.toString());
                    setState(() {});
                    return null;
                  },
                ),
                CommonButton(
                  text: 'isLogin',
                  onPressed: () async {
                    final data = await ZaloFlutter.isLogin();
                    return '$data';
                  },
                ),
                CommonButton(
                  text: 'login',
                  onPressed: () async {
                    final data = await ZaloFlutter.login();
                    return jsonEncode(data.toJson());
                  },
                ),
                CommonButton(
                  text: 'getUserProfile',
                  onPressed: () async {
                    final data = await ZaloFlutter.getUserProfile();
                    return jsonEncode(data.toJson());
                  },
                ),
                CommonButton(
                  text: 'getUserFriendList',
                  onPressed: () async {
                    final data = await ZaloFlutter.getUserFriendList(
                      atOffset: 0,
                      count: 3,
                    );
                    return jsonEncode(data.toJson());
                  },
                ),
                CommonButton(
                  text: 'getUserInvitableFriendList',
                  onPressed: () async {
                    final data = await ZaloFlutter.getUserInvitableFriendList(
                      atOffset: 0,
                      count: 3,
                    );
                    final rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
                CommonButton(
                  text: 'sendMessage',
                  onPressed: () async {
                    final data = await ZaloFlutter.sendMessage(
                      to: "2961857761415564889",
                      message: "Hello",
                      link: "www.google.com",
                    );
                    final rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
                CommonButton(
                  text: 'postFeed',
                  onPressed: () async {
                    final data = await ZaloFlutter.postFeed(
                      message: "Hello",
                      link: "www.google.com",
                    );
                    final rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
                CommonButton(
                  text: 'sendAppRequest',
                  onPressed: () async {
                    final data = await ZaloFlutter.sendAppRequest(
                      to: ["514969331990175590"],
                      message: "Hello",
                    );
                    final rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommonButton extends StatefulWidget {
  final String text;
  final Future<String?> Function() onPressed;
  final Color color;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  String? result;

  @override
  Widget build(BuildContext context) {
    final childText = Text(
      widget.text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    final button = MaterialButton(
      minWidth: double.infinity,
      height: 40,
      color: widget.color,
      padding: const EdgeInsets.all(16),
      onPressed: () async {
        print('[commonButton] ${widget.text}');
        result = await widget.onPressed();
        setState(() {});
      },
      shape: const StadiumBorder(),
      child: childText,
    );

    Widget showResult(String? text) {
      if (text == null) return Container();
      final object = jsonDecode(text);
      final prettyString = const JsonEncoder.withIndent('  ').convert(object);
      return Text(prettyString);
    }

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          button,
          showResult(result),
        ],
      ),
    );
  }
}
