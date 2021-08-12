import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zalo_flutter/zalo_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  int _indexReset = -1;
  ValueKey<String> _key = const ValueKey<String>('');

  String zaloId = '';
  String zaloMessage = '';
  String zaloLink = '';

  @override
  void initState() {
    super.initState();
    _initZaloFlutter();
  }

  Future<void> _initZaloFlutter() async {
    if (Platform.isAndroid) {
      final String? hashKey = await ZaloFlutter.getHashKeyAndroid();
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
                    _key = ValueKey<String>(_indexReset.toString());
                    setState(() {});
                    return null;
                  },
                ),
                CommonButton(
                  text: 'logout',
                  onPressed: () async {
                    await ZaloFlutter.logout();
                    _indexReset++;
                    _key = ValueKey<String>(_indexReset.toString());
                    setState(() {});
                    return null;
                  },
                ),
                CommonButton(
                  text: 'isLogin',
                  onPressed: () async {
                    final bool data = await ZaloFlutter.isLogin();
                    final String? x = data.toString();
                    return x;
                  },
                ),
                CommonButton(
                  text: 'login',
                  onPressed: () async {
                    final ZaloLogin data = await ZaloFlutter.login();
                    return jsonEncode(data.toJson());
                  },
                ),
                CommonButton(
                  text: 'getUserProfile',
                  onPressed: () async {
                    final ZaloProfile data = await ZaloFlutter.getUserProfile();
                    return jsonEncode(data.toJson());
                  },
                ),
                CommonButton(
                  text: 'getUserFriendList',
                  onPressed: () async {
                    final ZaloUserFriend data =
                        await ZaloFlutter.getUserFriendList(
                      atOffset: 0,
                      count: 3,
                    );
                    return jsonEncode(data.toJson());
                  },
                ),
                CommonButton(
                  text: 'getUserInvitableFriendList',
                  onPressed: () async {
                    final ZaloUserFriend data =
                        await ZaloFlutter.getUserInvitableFriendList(
                      atOffset: 0,
                      count: 3,
                    );
                    final String rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
                CommonButton(
                  text: 'sendMessage',
                  onPressed: () async {
                    final ZaloSendMessage data = await ZaloFlutter.sendMessage(
                      to: zaloId,
                      message: zaloMessage,
                      link: zaloLink,
                    );
                    final String rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
                CommonButton(
                  text: 'postFeed',
                  onPressed: () async {
                    final ZaloPostFeed data = await ZaloFlutter.postFeed(
                      message: zaloMessage,
                      link: zaloLink,
                    );
                    final String rs = jsonEncode(data.toJson());
                    return rs;
                  },
                ),
                CommonButton(
                  text: 'sendAppRequest',
                  onPressed: () async {
                    final ZaloSendAppRequest data =
                        await ZaloFlutter.sendAppRequest(
                      to: <String>[zaloId],
                      message: zaloMessage,
                    );
                    final String rs = jsonEncode(data.toJson());
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
  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
  }) : super(key: key);

  final String text;
  final Future<String?> Function() onPressed;
  final Color color;

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  String? result;

  @override
  Widget build(BuildContext context) {
    final Widget childText = Text(
      widget.text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    final Widget button = MaterialButton(
      minWidth: double.infinity,
      height: 40,
      color: widget.color,
      padding: const EdgeInsets.all(16),
      onPressed: () async {
        _showLoading(context);
        final DateTime time = DateTime.now();
        print('[$time][commonButton] ${widget.text}');
        result = await widget.onPressed();
        setState(() {});
        Navigator.pop(context);
      },
      shape: const StadiumBorder(),
      child: childText,
    );

    Widget showResult(String? text) {
      if (text == null) {
        return Container();
      }
      String data;
      try {
        final Map<String, dynamic>? object =
            jsonDecode(text) as Map<String, dynamic>?;
        data = const JsonEncoder.withIndent('  ').convert(object);
      } catch (e) {
        data = text;
      }
      return Text(data);
    }

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          button,
          showResult(result),
        ],
      ),
    );
  }

  Future<void> _showLoading(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
